# AES Encryption, Ruby to JS

This is a small demo of how to use AES 256 CBC to encrypt a string with Ruby and decrypt it with JS (plus some dependencies). The code was written quickly and inelegantly, so probably don't use it in production. If you stumbled here, the OpenSSL::Cipher::Cipher class is deprecated in recent versions of Ruby. See more recent [docs](https://ruby-doc.org/stdlib-2.0.0/libdoc/openssl/rdoc/OpenSSL/Cipher.html).

## To Run

To use the JS script, you need to install the dependencies in `package.json` with npm or yarn.

First, run the ruby encryptor script with a text string as a command-line argument. This will output a text file containing an encrypted string as Base64 text.

Next, run the JS decryptor script. This will read the file output of the encryptor script and write the decrypted result.
