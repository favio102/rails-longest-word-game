require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = generate_grid(10).join(' ')
  end

  def score
    word = params[:word]
    if @letters.nil?
      @message = "#{word} and #{@letters}"
    elsif include?(word.upcase)
      if english_word?(word)
        @message = "Congratulations! #{word} is a valid English word!"
      else
        @message = "Sorry but #{word} does not seem to be a valid English word"
      end
    else
      @message = "Sorry but #{word} can not be built out #{@letters}"
    end
  end

  def generate_grid(grid_size)
    Array.new(grid_size) { ('A'..'Z').to_a.sample }
  end

  def include?(guess, letters)
    guess.chars.all? { |letter| guess.count(letter) <= letters.count(letter) }
  end

  def english_word?(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end
end
