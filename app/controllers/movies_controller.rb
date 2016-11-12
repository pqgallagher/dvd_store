class MoviesController < ApplicationController
  def index
    @movies = Movie.order(:title)
  end

  def show
    @movie = find_movie
  end

  private
  def find_movie
    Movie.find(params[:id])
  end

  def movie_params
    params.require(:movie).permit(:title)
  end
end
