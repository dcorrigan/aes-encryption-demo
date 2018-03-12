// To use this script, first run the Ruby script, which will output an
// encrypted string to a file for demo purposes.
// Then run this script, which will read the output file, parse the data, and
// decrypt the message.

// CryptoJS is a common library for block-cipher and other encryption
// strategies: https://www.npmjs.com/package/crypto-js
var CryptoJS = require('./node_modules/crypto-js/index.js');
// atob for converting Base64 to binary
var atob = require('./node_modules/atob/node-atob.js');
var fs = require('fs');
var path = require('path');
var filePath = path.join(__dirname, 'code-ruby-encrypted.txt');

// The decryption method here is described in this stackoverflow answer:
// https://stackoverflow.com/a/15125030

// Use a very simple example key
var key = '1234'.repeat(16);
fs.readFile(filePath, {encoding: 'ascii'}, function(err,data){
  if (!err) {
    // convert data from base64 to binary
    var rawData = atob(data);
    // get the first 16 bytes; this is the initialization vector
    var iv = rawData.substring(0,16);
    // the remainder of the string is the ciphertext
    var crypttext = rawData.substring(16);
    // CryptoJS produces and expects array representations of strings; this is
    // what its decrypt method produces here
    var plaintextArray = CryptoJS.AES.decrypt(
      // parsing the ciphertext as Latin1 produces the array CryptoJS expects
      { ciphertext: CryptoJS.enc.Latin1.parse(crypttext) },
      // parse the key as hex
      CryptoJS.enc.Hex.parse(key),
      // same as ciphertext, produce an array representation of the IV
      { iv: CryptoJS.enc.Latin1.parse(iv) }
    );
    console.log("the following output should be the same as your input to encryptor.rb");
    // CryptoJS has facilities for converting its array representation to strings
    console.log(CryptoJS.enc.Latin1.stringify(plaintextArray));
  } else {
    console.log(err);
  }
});
