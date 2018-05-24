# CL-BIP39

CL-BIP39 is Common Lisp implementation of [BIP-0039](https://github.com/bitcoin/bips/blob/master/bip-0039.mediawiki) based on the [reference implementation](https://github.com/trezor/python-mnemonic).

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
CL-USER> (cl-bip39:generate-bip39-seed "coconut humble brave team ranch fossil soft mixed jewel favorite party tumble evil science february wealth visual labor")
"a997877d974a221bd6bd86759c12d974742b16657affb56146abd097c48ce790e5276ff87ff3c40778f9f979224ec57ce226a929c84b8e08c2a04f1042ee2909"
CL-USER> (cl-bip39:generate-bip39-seed "coconut humble brave team ranch fossil soft mixed jewel favorite party tumble evil science february wealth visual labor" "cl-bip39")
"e7bb643ffad51b944e2f33a142fd6efbc3f99b0550efbf87f2e94b9a5de87767e19bce09bec5174ff48eda67bb03844b16489de334bdd1989c4c4473949ad8d7"
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

