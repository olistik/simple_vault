require "spec_helper"

describe SimpleVault do
  it "has a version number" do
    expect(SimpleVault::VERSION).not_to be nil
  end

  it "encrypt and decrypt correctly" do
    plaintext = "Hello World"
    key = SimpleVault::hash_password("My-secret.")
    ciphertext = SimpleVault::encrypt(plaintext: plaintext, key: key)
    result = SimpleVault::decrypt(ciphertext: ciphertext, key: key)
    expect(result).to eql(plaintext)
  end

end
