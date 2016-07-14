class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end
  attr_accessor :guesses
  attr_accessor :wrong_guesses
  attr_accessor :word
  
  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end

  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.post_form(uri ,{}).body
  end
  
  def guess(letter)
    count = 0
    raise ArgumentError if (letter<=>'')==0
    raise ArgumentError if (letter<=>nil)==0
    raise ArgumentError if /[^[:alpha:]]/.match(letter)
    return false if /[A-Z]/.match(letter)
    @guesses.each_char {|g| return false if (letter<=>g)==0}
    @wrong_guesses.each_char {|g| return false if (letter<=>g)==0}
    @word.each_char {|w| count +=1 if (letter<=>w)==0}
    if count > 0
      @guesses +=letter
    else
      @wrong_guesses +=letter
    end
    return true
  end
  
  def guess_several_letters(letters)
    letters.each_char do |letter|
      return true if guess(letter)
    end
    return false
  end
  def check_win_or_lose
    return :lose if @wrong_guesses.length >= 7
    return :win if @word.length == @guesses.length
    return :play
  end
  def word_with_guesses
    display = ""
    @word.each_char do |w|
      guessed = "-"
      @guesses.each_char do |g| 
        if (w<=>g)==0
          guessed = w
        end
      end
      display += guessed
    end
    return display
  end
end