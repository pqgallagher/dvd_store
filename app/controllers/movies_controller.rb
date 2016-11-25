class MoviesController < ApplicationController
  before_action :initialize_session
  before_action :load, only: [:index]

  def index
    @categories = Category.all
    @sale_new = ['New', 'Sale']
    @sales_tax_by_province = SalesTax.all

    if session[:sort].present? && session[:search].present?
      @movies = Movie.where("title LIKE ?", "%"+session[:search]+"%").where(category_id: session[:sort])
    elsif session[:sort].present?
      @movies = Movie.where(category_id: session[:sort])
    elsif session[:search].present?
      @movies = Movie.where("title LIKE ?", "%"+session[:search]+"%")
    elsif session[:sale_new].present?
      if session[:sale_new] == 'Sale'
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

  def sum_session(amount)
    total = 0
    amount.each do |num|
      total += num.to_f
    end
    return total
  end

  def add_to_cart
   id = params[:id].to_i
   quantity = params[:quantity_selection].to_i
   amount = find_movie.price * quantity

   session[:movies_in_cart][0] << id unless session[:movies_in_cart][0].include?(id)
   session[:movies_in_cart][1] << quantity
   session[:subtotal] <<  amount

   redirect_to index_path
  end

  def update_quantity
    quantity = params[:quantity_update].to_i
    amount = find_movie.price * quantity
    index = session[:movies_in_cart][0].index(params[:id].to_i)

    session[:movies_in_cart][1][index] = quantity
    session[:subtotal][index] = amount
    redirect_to index_path
  end

  def remove_from_cart
    id = params[:id].to_i
    index = session[:movies_in_cart][0].index(id)

    session[:movies_in_cart][0].delete(id)
    session[:movies_in_cart][1].delete_at(index)
    session[:subtotal].delete_at(index)

    redirect_to index_path
  end

  def remove_all
    session[:movies_in_cart][0] = []
    session[:movies_in_cart][1] = []
    session[:subtotal] = []

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
    id = params[:sort_id].to_i

    if id != 0
      session[:sort] = id
    else
      session[:sort] = []
    end

    session[:search] = name
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

  def set_pst
     session[:PST] = SalesTax.where(id: params[:province_selection].to_i).first.pst
     session[:province] = SalesTax.where(id: params[:province_selection].to_i).first.province

     redirect_to index_path
  end

  def reset_pst
    session[:PST] = []
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
    session[:movies_in_cart] ||= Array.new(2) { Array.new() }
    session[:sort] ||= []
    session[:search] ||= []
    session[:sale_new] ||= []
    session[:subtotal] ||= []
    session[:GST] ||= SalesTax.all.first.gst
    session[:PST] ||= []
    session[:province] ||= []
    session[:id] ||= []
  end

  def load
    @movies_in_cart = Movie.find(session[:movies_in_cart][0])
    @subtotal = sum_session(session[:subtotal]).round(2)
    @quantity = session[:movies_in_cart][1]
    @item_totals = session[:subtotal]
    @pst = session[:PST]
    @gst = session[:GST]
    @province = session[:province]
  end

end
