# CL-BIP39

CL-BIP39 is a Common Lisp implementation of [BIP-0039](https://github.com/bitcoin/bips/blob/master/bip-0039.mediawiki) based on the [reference implementation](https://github.com/trezor/python-mnemonic).

The library exports the following symbols:

* `generate-bip39-mnemonic` a function that generates a new mnemonic sentence
* `check-bip39-mnemonic` a function that verifies the validity of a given mnemonic sentence
* `generate-bip39-seed` a function that generates a binary seed from a given mnemonic sentence (and an optional passphrase)

## Getting Started

The following examples show how to create a mnemonic sentence,
validate it, and use it to generate a seed.

````lisp
CL-USER> (cl-bip39:generate-bip39-mnemonic)
"rice grocery immense truck brave spread coin quality depend angle appear stuff"
CL-USER> (cl-bip39:bip39-mnemonic-p "rice grocery immense truck brave spread coin quality depend angle appear stuff")
T
CL-USER> (cl-bip39:generate-bip39-seed "rice grocery immense truck brave spread coin quality depend angle appear stuff")
"0bc0120ad16a21cab358d0cfe0030bc2bb53b906ea7fe6653ca414d6bb0ce1e0f4f262479164a5480f9d110c6fec017738dfb64bba347386f3a455d9213cf015"
````

Of course, it is possible to generate a mnemonic sentence with different length:

````lisp
CL-USER> (cl-bip39:generate-bip39-mnemonic :entropy-size 192)
"coconut humble brave team ranch fossil soft mixed jewel favorite party tumble evil science february wealth visual labor"
````

And it is also possible to generate a seed with (and without) a passphrase:

````lisp
CL-USER> (defparameter *mnemonic* (cl-bip39:generate-bip39-mnemonic))
*MNEMONIC*
CL-USER> (cl-bip39:generate-bip39-seed *mnemonic* "a-passphrase")
"ff04e5d7adfa23f2df26dfb2d158ed210378058d755d30bf3b18466411b83b42b3ed1f2043abd19310bd40c06c022cf8bc8baf626b1c673df48aa0cd0b27c03a"
CL-USER> (cl-bip39:generate-bip39-seed *mnemonic*)
"976282dccc72387628ccc76553bd06472eb4464e77a578132f1f0d0c37290e8f9c567ba7ab0390d175a742555fb55c8de6798c67c9302234803013d47e6651a4"
````

## Limitations

* Currently, the library only supports the English language wordlist.

## Dependencies

* **secure-random**
* **ironclad**
* **split-sequence**
* **trivial-utf-8**

## Author & Maintainer

Smith Dhumbumroong (<zodmaner@gmail.com>)

## License

Copyright (c) 2018 Smith Dhumbumroong

Licensed under the MIT License.

