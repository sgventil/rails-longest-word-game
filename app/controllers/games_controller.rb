require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    alphabet = ('a'..'z').to_a
    vowels = %w[a e i o u]
    @letters = Array.new(10) do
      if rand < 0.22
        vowels.sample
      else
        alphabet.sample
      end
    end
  end

  def score
    @result = { score: 0, message: '' }
    word_score = params[:word].size.to_i * 10
    url = "https://wagon-dictionary.herokuapp.com/#{params[:word]}"
    html_file = URI.open(url).read
    ruby_hash = JSON.parse(html_file)
    if params[:word].upcase.chars.all? { |c| params[:letters].upcase.include?(c) } == false
      @result = { score: 0, message: "Sorry but #{params[:word].upcase} can't be built out of #{params[:letters].upcase}" }
    elsif ruby_hash['found']
      @result = { score: word_score, message: "Congratulations! #{params[:word]} is a valid English word!" }
      session[:scores] ||= []
      session[:scores] << word_score
    else
      @result = { score: 0, message: "Sorry but #{params[:word]} does not seem to be a valid English word.." }
    end
    total_score = session[:scores].sum
    session[:total_score] = total_score
  end
end
