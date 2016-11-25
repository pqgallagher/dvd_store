class UsersController < ApplicationController
  before_action :load, only: [:index]

  def index
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to index_path
      session[:movies_in_cart][0] = []
      session[:movies_in_cart][1] = []
      session[:subtotal] = []
      session[:id] = @user.id
    else
      load
      render :index
    end
  end

  def sum_session(amount)
    total = 0
    amount.each do |num|
      total += num.to_f
    end
    return total
  end

  private
  def load
    @movies_in_cart = Movie.find(session[:movies_in_cart][0])
    @subtotal = sum_session(session[:subtotal]).round(2)
    @quantity = session[:movies_in_cart][1]
    @item_totals = session[:subtotal]
    @pst = session[:PST]
    @gst = session[:GST]
    @province = session[:province]
  end

  def user_params
    params.require(:user).permit(:fname, :lname, :address, :pcode, :email)
  end
end
