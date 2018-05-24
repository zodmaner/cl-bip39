;;;; cl-bip39.lisp

(in-package #:cl-bip39)

(define-condition invalid-entropy-size (error)
  ((size :initarg :size
         :reader size))
  (:report (lambda (condition stream)
             (format stream
                     "~A is an invalid entropy size, must be one of the following: 128, 160, 192, 224, 256."
                     (size condition)))))

(define-condition invalid-word (error)
  ((word :initarg :word
         :reader word))
  (:report (lambda (condition stream)
             (format stream
                     "The word \"~A\" is not part of the wordlist."
                     (word condition)))))

(define-condition invalid-mnemonic-sentence-length (error)
  ((len :initarg :len
        :reader len))
  (:report (lambda (condition stream)
             (format stream
                     "Invalid mnemonic sentence length: ~A."
                     (len condition)))))

(defun sha256 (byte-sequence)
  (ironclad:digest-sequence :sha256 byte-sequence))

(defun bits-to-bytes (bits)
  (/ bits 8))

(defun byte-array-to-int (byte-array)
  (parse-integer (ironclad:byte-array-to-hex-string byte-array)
                 :radix 16))

(defun bit-string-to-int (bit-string)
  (parse-integer bit-string :radix 2))

(defun int-to-byte-array (int)
  (ironclad:integer-to-octets int))

(defun entropy-to-bit-string (entropy entropy-size)
  (cond ((= entropy-size 128)
         (format nil "~128,'0B" (byte-array-to-int entropy)))
        ((= entropy-size 160)
         (format nil "~160,'0B" (byte-array-to-int entropy)))
        ((= entropy-size 192)
         (format nil "~192,'0B" (byte-array-to-int entropy)))
        ((= entropy-size 224)
         (format nil "~224,'0B" (byte-array-to-int entropy)))
        ((= entropy-size 256)
         (format nil "~256,'0B" (byte-array-to-int entropy)))
        (t (error 'invalid-entropy-size :size entropy-size))))

(defun checksum-to-bit-string (checksum entropy-size)
  (subseq (format nil "~256,'0B" (byte-array-to-int checksum))
          0 (/ entropy-size 32)))

(defun cs-position (ent+cs-bit-string)
  (* (/ (length ent+cs-bit-string) 33) 32))

(defun split-mnemonic (mnemonic)
  (let* ((mnemonic-list (split-sequence:split-sequence #\Space mnemonic))
         (mnemonic-length (length mnemonic-list)))
    (if (find mnemonic-length '(12 15 18 21 24) :test #'=)
        mnemonic-list
        (error 'invalid-mnemonic-sentence-length :len mnemonic-length))))

(defun mnemonic-word-to-index (mnemonic-word)
  (let ((word-index (position mnemonic-word *word-list-english* :test #'string=)))
    (if word-index
        word-index
        (error 'invalid-word :word mnemonic-word))))

(defun generate-initial-entropy (entropy-size)
  (when (not (find entropy-size '(128 160 192 224 256 :test #'=)))
    (error 'invalid-entropy-size :size entropy-size))
  (secure-random:bytes (bits-to-bytes entropy-size) secure-random:*generator*))

(defun generate-bip39-mnemonic (&key (entropy-size 128))
  (let* ((entropy (generate-initial-entropy entropy-size))
         (ent-bit-string (entropy-to-bit-string entropy entropy-size))
         (checksum (sha256 entropy))
         (cs-bit-string (checksum-to-bit-string checksum entropy-size))
         (ent+cs-bit-string (concatenate 'string ent-bit-string cs-bit-string)))
    (loop :for i :below (/ (length ent+cs-bit-string) 11)
       :collect (aref *word-list-english*
                      (parse-integer ent+cs-bit-string
                                     :start (* i 11) :end (* (+ i 1) 11)
                                     :radix 2))
       :into mnemonic-list
       :finally (return (format nil "~{~A~^ ~}" mnemonic-list)))))

(defun bip39-mnemonic-p (mnemonic)
  (let* ((mnemonic-list (split-mnemonic mnemonic))
         (ent+cs-bit-string
          (format nil "~{~11,'0B~}"
                  (mapcar #'mnemonic-word-to-index mnemonic-list)))
         (ent-bit-string (subseq ent+cs-bit-string
                                 0 (cs-position ent+cs-bit-string)))
         (entropy (int-to-byte-array (bit-string-to-int ent-bit-string)))
         (cs-bit-string (subseq ent+cs-bit-string
                                (cs-position ent+cs-bit-string))))
    (string= cs-bit-string
             (checksum-to-bit-string (sha256 entropy) (length ent-bit-string)))))

(defun generate-bip39-seed (mnemonic &optional passphase)
  (bip39-mnemonic-p mnemonic)
  (ironclad:byte-array-to-hex-string
   (ironclad:pbkdf2-hash-password (trivial-utf-8:string-to-utf-8-bytes mnemonic)
                                  :salt (trivial-utf-8:string-to-utf-8-bytes
                                         (concatenate 'string "mnemonic" passphase))
                                  :digest :sha512
                                  :iterations 2048)))
