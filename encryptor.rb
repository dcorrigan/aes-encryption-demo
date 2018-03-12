require 'openssl'

# https://ruby-doc.org/stdlib-1.9.3/libdoc/openssl/rdoc/OpenSSL/Cipher.html
# 1.8.7 is the MRI equivalent of our JRuby version, but I've linked the 1.9.3
# docs because they have better explanations and the API we need is the same
module Encryptor
  ALG = 'AES-256-CBC'.freeze

  def self.encrypt(msg, key)
    # initialize a new cipher instance with the algorithm specified
    aes = OpenSSL::Cipher::Cipher.new(ALG)
    # the encrypt method tells the object what we intend to use it for
    aes.encrypt
    # convert the key to hex and assign it to the cipher object
    aes.key = hex_key(key)
    # produce a random IV to use and assign
    iv = aes.random_iv
    aes.iv = iv
    # begin creating the cipher with the plain test value
    cipher = aes.update(msg)
    # finalize the cipher, handles padding
    cipher << aes.final
    # combine the IV and the cipher text and encode it as Base64; same as
    # saying Base64.encode64(iv + cipher)
    [iv + cipher].pack('m')
  end

  def self.decrypt(msg, key)
    unpacked = msg.unpack('m')[0]
    iv = unpacked.slice(0, 16)
    ciphertext = unpacked.slice(16, unpacked.length - 1)
    decode_cipher = OpenSSL::Cipher::Cipher.new(ALG)
    decode_cipher.decrypt
    decode_cipher.key = hex_key(key)
    decode_cipher.iv = iv
    plain = decode_cipher.update(ciphertext)
    plain << decode_cipher.final
    plain
  end

  def self.hex_key(k)
    k.scan(/../).collect(&:hex).pack('c*')
  end
end

# When converted to hex, this key becomes 256 bits. This is obviously a bad
# key; in reality, you would probably want a randomly generated one also
# encoded as base64 to make it easy to store for all the client-side
# applications.
key = '1234' * 16
enc = Encryptor.encrypt(ARGV[0], key)
File.open('code-ruby-encrypted.txt', 'w:ascii') { |f| f << enc }
