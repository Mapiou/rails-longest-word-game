require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times { @letters << ("A".."Z").to_a.sample }
  end

  def score
    @letters = params[:letters]
    @word = params[:word]
    @result = {}
    if grid?(@word.upcase, @letters.strip)
      if dictionnary?(@word)
        @result[:message] = "Congratulations! #{@word.upcase} is a valid English word!"
      else
        @result[:message] = "Sorry but #{@word.upcase} does not seem to be a valid English word..."
      end
    else
      @result[:message] = "Sorry but #{@word.upcase} can't be built out of #{@letters}"
    end
  end

  private

  def grid?(attempt, grid)
    return attempt.chars.all? { |letter| attempt.count(letter) <= grid.count(letter) }
  end

  def dictionnary?(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    word_serialized = open(url).read
    word = JSON.parse(word_serialized)
    return word["found"]
  end

end
