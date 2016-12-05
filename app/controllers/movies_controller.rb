class MoviesController < ApplicationController
  before_action :initialize_session
  # Sets the class variables to all the values in the session variables.
  before_action :load, only: [:index]

  def index
    # Sets the class variables to the data from the database.
    @categories = Category.all
    @sale_new = ['New', 'Sale']
    @sales_tax_by_province = SalesTax.all

    # When Searching for movie by title and category.
    if session[:sort].present? && session[:search].present?
       # Searches the database for movie titles like the user's input and by category.
      @movies = Movie.where("title LIKE ?", "%"+session[:search]+"%").where(category_id: session[:sort])
    # When sorting the movies by selected category.
    elsif session[:sort].present?
      @movies = Movie.where(category_id: session[:sort])
    # When Searching for movie by title.
    elsif session[:search].present?
      # Searches the database for movie titles like the user's input.
      @movies = Movie.where("title LIKE ?", "%"+session[:search]+"%")
    # When displaying the new movies and the movies on sale.
    elsif session[:sale_new].present?
      # For movies on sale.
      if session[:sale_new] == 'Sale'
        @movies = Movie.where(sale: true)
      # For newer movies.
      else
        @movies = Movie.where(new: true)
      end
    else
      # Displays all movies alphabetically when no session variables are set.
      @movies = Movie.order(:title)
    end
  end

  # Displays the details page of the movie.
  def show
    # Gets the movie id.
    @movie = find_movie
  end

  # Sums the values of the array passed in.
  def sum_session(amount)
    total = 0
    amount.each do |num|
      total += num.to_f
    end
    return total
  end

  # Adding the selected movie to the cart.
  def add_to_cart
   id = params[:id].to_i
   quantity = params[:quantity_selection].to_i
   # Gets the price of the movie and times it by the quantity.
   amount = find_movie.price * quantity

   # Adds the movie id to the first layer of the
   # session, unless it's already in the session.
   session[:movies_in_cart][0] << id unless session[:movies_in_cart][0].include?(id)
   # Adds the quantity to the second layer of the session.
   session[:movies_in_cart][1] << quantity
   # Adds the amount to the subtotal session.
   session[:subtotal] <<  amount

   redirect_to index_path
  end

  # Updated the quantity of selected movie in the cart.
  def update_quantity
    quantity = params[:quantity_update].to_i
    # Gets the price of the movie and times it by the quantity.
    amount = find_movie.price * quantity

    # Gets the index of the array from the first layer of the
    # array to match the second.
    index = session[:movies_in_cart][0].index(params[:id].to_i)
    # Updates the quantity in the second layer of the array
    # based on the index.
    session[:movies_in_cart][1][index] = quantity
    # Updates the subtotal of the based on the index.
    session[:subtotal][index] = amount
    redirect_to :back
  end

  # Removes the selected movie from the cart.
  def remove_from_cart
    id = params[:id].to_i

    # Gets the index of the array.
    index = session[:movies_in_cart][0].index(id)

    # Deletes the movie from all the sessions based on index.
    session[:movies_in_cart][0].delete(id)
    session[:movies_in_cart][1].delete_at(index)
    session[:subtotal].delete_at(index)

    # If there all still movies in the cart
    # the user is sent back to the previous screen.
    if session[:movies_in_cart][0].any?
      redirect_to :back
    else
      redirect_to index_path
    end

  end

  # Removes all movies from the cart by
  # clearing all the sessions.
  def remove_all
    session[:movies_in_cart][0] = []
    session[:movies_in_cart][1] = []
    session[:subtotal] = []

    redirect_to index_path
  end

  # Clears all the sorting sessions to show all movies.
  def show_all
    session[:sort] = []
    session[:search] = []
    session[:sale_new] = []

    redirect_to index_path
  end

  # When searching a movie by title.
  def search
    name = params[:search_name]
    id = params[:sort_id].to_i

    # If a selection was made by the user.
    if id != 0
      session[:sort] = id
    else
      session[:sort] = []
    end

    session[:search] = name
    # Clears sale new sort.
    session[:sale_new] = []

    redirect_to index_path
  end

  # When displaying the new movies
  # and the movies on sale.
  def sale_new
    selection = params[:sale_new_id].to_s
    session[:sale_new] = selection
    # Clears sort and search.
    session[:sort] = []
    session[:search] = []

    redirect_to index_path
  end

  # Sets the PST based on user selection.
  def set_pst
     session[:PST] = SalesTax.where(id: params[:province_selection].to_i).first.pst
     session[:province] = SalesTax.where(id: params[:province_selection].to_i).first.province

     redirect_to :back
  end

  # Resets the PST for a new selection.
  def reset_pst
    session[:PST] = []

    redirect_to :back
  end

  # Clears the login session.
  def logout
    session[:login] = []
    redirect_to :back
  end

  private
  # Finds the moive based on the id.
  def find_movie
    Movie.find(params[:id])
  end

  # Sets the params for the various forms.
  def movie_params
    params.require(:movie).permit(:title)
  end

  def initialize_session
    # Sets the session as a double layer array.
    session[:movies_in_cart] ||= Array.new(2) { Array.new() }
    session[:sort] ||= []
    session[:search] ||= []
    session[:sale_new] ||= []
    session[:subtotal] ||= []
    # Sets the GST to 5%.
    session[:GST] ||= SalesTax.all.first.gst
    session[:PST] ||= []
    session[:province] ||= []
  end

  # Sets the class variables to all the values in the session variables.
  def load
    @movies_in_cart = Movie.find(session[:movies_in_cart][0])
    @subtotal = sum_session(session[:subtotal]).round(2)
    @quantity = session[:movies_in_cart][1]
    @item_totals = session[:subtotal]
    @pst = session[:PST]
    @gst = session[:GST]
    @province = session[:province]
    @user = session[:login]
  end

end
