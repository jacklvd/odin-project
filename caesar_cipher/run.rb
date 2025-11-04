=begin
In cryptography, a Caesar cipher, also known as Caesar’s cipher, the shift cipher, Caesar’s code or Caesar shift, 
is one of the simplest and most widely known encryption techniques. It is a type of substitution cipher in 
which each letter in the plaintext is replaced by a letter some fixed number of positions down the alphabet. 
For example, with a left shift of 3, D would be replaced by A, E would become B, and so on. 
The method is named after Julius Caesar, who used it in his private correspondence.
=end

class CaesarCipher
  ALPHABET_SIZE = 26

  def initialize(shift)
    @shift = shift % ALPHABET_SIZE
  end

  def encrypt(plaintext)
    transform(plaintext, @shift)
  end

  def decrypt(ciphertext)
    transform(ciphertext, -@shift)
  end

  private

  def transform(text, shift)
    text.chars.map do |char|
      if char =~ /[A-Za-z]/
        base = char.ord < 91 ? 'A'.ord : 'a'.ord
        (((char.ord - base + shift) % ALPHABET_SIZE) + base).chr
      else
        char
      end
    end.join
  end
end

# Example usage:
cipher = CaesarCipher.new(3)
encrypted = cipher.encrypt("Hello, World!")
decrypted = cipher.decrypt(encrypted)

puts "Encrypted: #{encrypted}" # Khoor, Zruog!
puts "Decrypted: #{decrypted}" # Hello, World!