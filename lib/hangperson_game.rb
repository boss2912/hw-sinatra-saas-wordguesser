class HangpersonGame
  attr_accessor :word, :guesses, :wrong_guesses

  def initialize(word)
    @word = word.downcase
    @guesses = ''
    @wrong_guesses = ''
  end

  def guess(letter)
    raise ArgumentError, "Guess cannot be nil, empty, or non-letter" if letter.nil? || letter.empty? || letter !~ /^[a-zA-Z]$/
    
    letter = letter.downcase
    return false if guesses.include?(letter) || wrong_guesses.include?(letter)

    if word.include?(letter)
      @guesses += letter
    else
      @wrong_guesses += letter
    end
    true
  end

  def word_with_guesses
    word.chars.map { |c| guesses.include?(c) ? c : '-' }.join
  end

  def check_win_or_lose
    return :win if word_with_guesses == word
    return :lose if wrong_guesses.length >= 7
    :play
  end

  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://randomword.saasbook.info/RandomWord')
    Net::HTTP.get(uri).strip.downcase
  end
end
