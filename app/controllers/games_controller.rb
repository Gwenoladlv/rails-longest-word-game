require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    a = ('A'..'Z').to_a
    @letters = a.sample(10)
  end

  def score
    @word = params[:word]
    @letters = params[:letters].split(' ')
    result = { score: 0, message: 'not an english word' }
    if word_exist?(@word)
      if included?(@word.upcase, @letters)
        result[:score] = (@word.size * 2)
        result[:message] = 'well done'
      else
        result = { score: 0, message: 'not in the grid' }
      end
    end
    @results = result
  end

  private

  def word_exist?(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    response_serialized = URI.open(url).read
    response = JSON.parse(response_serialized)
    response['found']
  end

  def included?(attempt, grid)
    attempt.chars.all? { |letter| attempt.chars.count(letter) <= grid.count(letter) }
  end
end
