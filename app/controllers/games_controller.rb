require 'json'
require 'net/http'

class GamesController < ApplicationController
  def new
    user_id = SecureRandom.uuid
    session[:user_id] = user_id
    @letters = []
    vowels = %w[a e i o u]
    @letters += vowels.sample(3) + (('a'..'z').to_a - vowels).sample(7)
    @letters.shuffle!
  end

  def score
    user_id = session[:user_id]
    @letters = params[:letters]
    @word = params[:word] || ''
    uri = URI("https://wagon-dictionary.herokuapp.com/#{@word}")
    response = Net::HTTP.get(uri)
    @repos = JSON.parse(response)
    word_chars = @word.downcase.chars
    @can_be_composed = word_chars.all? { |char| @letters.include?(char) }
    @score = @repos['length'].to_i * @repos['length'].to_i
    @total_score = session[:total_score].to_i
    @total_score += @score
    session[:total_score] = @total_score
  end
end
