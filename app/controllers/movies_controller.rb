class MoviesController < ApplicationController
  before_action :initialize_session
  before_action :load_movies_in_cart, only: [:index]

  def index
    @categories = Category.all
    @sale_new = ['New', 'Sale']

    if session[:sort].present?
      @movies = Movie.where(category_id: session[:sort])
    elsif session[:search].present?
      @movies = Movie.where("title LIKE ?", "%"+session[:search]+"%")
    elsif session[:sale_new].present?
      if session[:sale_new] == 'New'
        @movies = Movie.where(sale: true)
      else
        @movies = Movie.where(new: true)
      end

    else
      @movies = Movie.order(:title)
    end
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
    id = params[:sort_id].to_i
    session[:sort] = id
    session[:search] = []

    redirect_to index_path
  end

  def show_all
    session[:sort] = []
    session[:search] = []
    session[:sale_new] = []

    redirect_to index_path
  end

  def search
    name = params[:search_name]
    session[:search] = name
    session[:sort] = []
    session[:sale_new] = []

    redirect_to index_path
  end

  def sale_new
    selection = params[:sale_new_id].to_s
    session[:sale_new] = selection
    session[:sort] = []
    session[:search] = []

    redirect_to index_path
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
    session[:sort] ||= []
    session[:search] ||= []
    session[:sale_new] ||= []
  end

  def load_movies_in_cart
    @movies_in_cart = Movie.find(session[:movies_in_cart])
  end

end
