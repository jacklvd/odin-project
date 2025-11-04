=begin

Implement a method #substrings that takes a word as the first argument and then an array of valid substrings 
(your dictionary) as the second argument. It should return a hash listing 
each substring (case insensitive) that was found in the original string and how many times it was found.

  > dictionary = ["below","down","go","going","horn","how","howdy","it","i","low","own","part","partner","sit"]
  => ["below","down","go","going","horn","how","howdy","it","i","low","own","part","partner","sit"]
  > substrings("below", dictionary)
  => { "below" => 1, "low" => 1 }

=end


def substrings(word, dictionary)
  result = Hash.new(0)
  downcased_word = word.downcase

  dictionary.each do |substring|
    downcased_substring = substring.downcase
    count = downcased_word.scan(/(?=#{downcased_substring})/).size
    result[substring] += count if count > 0
  end

  return result
end

# test examples
dictionary = ["below","down","go","going","horn","how","howdy","it","i","low","own","part","partner","sit"]
puts substrings("below", dictionary) # => { "below" => 1, "low" => 1 }
puts substrings("Howdy partner, sit down! How's it going?", dictionary)
# => { "howdy" => 1, "partner" => 1, "sit" => 1, "down" => 1, "how" => 2, "it" => 1, "i" => 3, "go" => 1, "going" => 1 }