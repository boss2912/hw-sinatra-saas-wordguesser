require 'sinatra'
require_relative 'lib/hangperson_game'

enable :sessions

before do
  @game = session[:game] ||= HangpersonGame.new(HangpersonGame.get_random_word)
end

get '/' do
  redirect '/show'
end

get '/new' do
  erb :new
end

post '/create' do
  word = params[:word]&.strip&.downcase
  word = HangpersonGame.get_random_word if word.to_s.empty?
  session[:game] = HangpersonGame.new(word)
  redirect '/show'
end

post '/guess' do
  letter = params[:guess]&.strip
  begin
    success = @game.guess(letter)
    flash[:error] = "You have already guessed that letter." unless success
  rescue ArgumentError => e
    flash[:error] = e.message
  end
  redirect '/show'
end

get '/show' do
  case @game.check_win_or_lose
  when :win then redirect '/win'
  when :lose then redirect '/lose'
  end
  erb :show
end

get '/win' do
  erb :win
end

get '/lose' do
  erb :lose
end

helpers do
  def flash
    session[:flash] ||= {}
  end
end
