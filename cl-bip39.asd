;;;; cl-bip39.asd

(asdf:defsystem #:cl-bip39
  :description "Describe cl-bip39 here"
  :author "Your Name <your.name@example.com>"
  :license  "Specify license here"
  :version "0.0.1"
  :serial t
  :depends-on (#:secure-random
               #:ironclad
               #:split-sequence
               #:trivial-utf-8)
  :components ((:file "package")
               (:file "word-list-english")
               (:file "cl-bip39")))
