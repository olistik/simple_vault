require "simple_vault/version"

require "json"
require "base64"
require "rbnacl/libsodium"

module SimpleVault

  extend self

  def generate_secret_key(password:)
    hash = hash_password(password)
    base64 = Base64::encode64(hash)
    json = JSON::dump(base64)
    home_path = File.expand_path("~")
  end

  def encrypt(plaintext:, key:)
    box = box_from_secret_key(key: key)
    ciphertext = box.encrypt(plaintext)
  end

  def decrypt(ciphertext:, key:)
    box = box_from_secret_key(key: key)
    box.decrypt(ciphertext)
  end

  def hash_password(password)
    salt = RbNaCl::Random.random_bytes(RbNaCl::PasswordHash::SCrypt::SALTBYTES)
    opslimit = 2**20
    memlimit = 2**24
    digest_size = RbNaCl::SecretBox.key_bytes
    RbNaCl::PasswordHash.scrypt(
      password,
      salt,
      opslimit,
      memlimit,
      digest_size
    )
  end

  private

    def box_from_secret_key(key:)
      RbNaCl::SimpleBox.from_secret_key(key)
    end

end
