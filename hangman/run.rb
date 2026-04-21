require 'json'

WORD_FILE = File.join(__dir__, 'english-text.txt')
SAVE_FILE = File.join(__dir__, 'save.json')
MAX_WRONG = 6

HANGMAN = [
  %(
  +---+
  |   |
      |
      |
      |
      |
=========),
  %(
  +---+
  |   |
  O   |
      |
      |
      |
=========),
  %(
  +---+
  |   |
  O   |
  |   |
      |
      |
=========),
  %(
  +---+
  |   |
  O   |
 /|   |
      |
      |
=========),
  %(
  +---+
  |   |
  O   |
 /|\\  |
      |
      |
=========),
  %(
  +---+
  |   |
  O   |
 /|\\  |
 /    |
      |
=========),
  %(
  +---+
  |   |
  O   |
 /|\\  |
 / \\  |
      |
=========)
].freeze

def load_words
  File.readlines(WORD_FILE, chomp: true).select { |w| w.length.between?(5, 12) && w.match?(/\A[a-z]+\z/) }
end

def display(word, guessed, wrong)
  puts HANGMAN[wrong.length]
  puts "\n  " + word.chars.map { |c| guessed.include?(c) ? c : '_' }.join(' ')
  puts "\n  Wrong guesses (#{wrong.length}/#{MAX_WRONG}): #{wrong.join(', ')}" unless wrong.empty?
  puts
end

def won?(word, guessed)
  word.chars.all? { |c| guessed.include?(c) }
end

def save_game(word, guessed, wrong)
  File.write(SAVE_FILE, JSON.dump({ word: word, guessed: guessed, wrong: wrong }))
  puts '  Game saved.'
end

def load_game
  return nil unless File.exist?(SAVE_FILE)

  data = JSON.parse(File.read(SAVE_FILE), symbolize_names: true)
  [data[:word], data[:guessed], data[:wrong]]
end

def play(word, guessed, wrong)
  loop do
    display(word, guessed, wrong)

    if won?(word, guessed)
      puts "  You won! The word was: #{word}"
      File.delete(SAVE_FILE) if File.exist?(SAVE_FILE)
      return
    end

    if wrong.length >= MAX_WRONG
      puts "  Game over! The word was: #{word}"
      File.delete(SAVE_FILE) if File.exist?(SAVE_FILE)
      return
    end

    print "  Guess a letter (or 'save' / 'quit'): "
    input = gets.chomp.downcase.strip

    case input
    when 'save'
      save_game(word, guessed, wrong)
      next
    when 'quit'
      save_game(word, guessed, wrong)
      puts '  Goodbye!'
      return
    end

    unless input.match?(/\A[a-z]\z/)
      puts '  Enter a single letter.'
      next
    end

    if guessed.include?(input) || wrong.include?(input)
      puts "  You already guessed '#{input}'."
      next
    end

    if word.include?(input)
      guessed << input
    else
      wrong << input
    end
  end
end

def main
  puts "\n=== HANGMAN ===\n\n"

  if File.exist?(SAVE_FILE)
    print '  Saved game found. Load it? (y/n): '
    if gets.chomp.downcase == 'y'
      word, guessed, wrong = load_game
      File.delete(SAVE_FILE)
      play(word, guessed, wrong)
      return
    end
  end

  words = load_words
  word  = words.sample
  play(word, [], [])
end

main
