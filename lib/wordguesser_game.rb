class WordGuesserGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.

  # Get a word from remote "random word" service

  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
    @word_with_guesses = word.gsub(/./, '-')
    @check_win_or_lose = :play
  end

  attr_accessor :word, :guesses, :wrong_guesses, :word_with_guesses, :check_win_or_lose

  def guess(ltr)
    raise ArgumentError if ltr.nil? || ltr.empty? || ltr.index(/[[:alpha:]]/) == nil
    ltr.downcase!
    if @word.downcase.include?(ltr)
      return false if @guesses.include?(ltr)
      @guesses << ltr
      for i in 0...@word.length do
        @word_with_guesses[i] = @word[i] if @word[i].downcase == ltr[0]
      end
      @check_win_or_lose = :win if not @word_with_guesses.include?('-')
    else
      return false if @wrong_guesses.include?(ltr)
      @wrong_guesses << ltr
      @check_win_or_lose = :lose if @wrong_guesses.length >= 7
    end
    true
  end

  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://randomword.saasbook.info/RandomWord')
    Net::HTTP.new('randomword.saasbook.info').start { |http|
      return http.post(uri, "").body
    }
  end

end
