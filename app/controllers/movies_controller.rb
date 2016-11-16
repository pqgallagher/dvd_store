class MoviesController < ApplicationController
  before_action :initialize_session
  before_action :load_movies_in_cart, only: [:index]

  def index
    @movies = Movie.order(:title)
    # @categories = Category.all
  end

  def show
    @movie = find_movie
  end

  def add_to_cart
   id = params[:id].to_i
   session[:movies_in_cart] << id unless session[:movies_in_cart].include?(id)

   redirect_to index_path
  end

  def remove_from_cart
    id = params[:id].to_i
    session[:movies_in_cart].delete(id)

    redirect_to index_path
  end

  def remove_all
    session[:movies_in_cart] = []
    redirect_to index_path
  end

  def sort
  end

  private
  def find_movie
    Movie.find(params[:id])
  end

  def movie_params
    params.require(:movie).permit(:title)
  end

  def initialize_session
    session[:movies_in_cart] ||= []
  end

  def load_movies_in_cart
    @movies_in_cart = Movie.find(session[:movies_in_cart])
  end

end
