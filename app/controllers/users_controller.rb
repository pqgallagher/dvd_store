class UsersController < ApplicationController
  before_action :load, only: [:index]

  def index
    @user = User.new
    @sales_tax_by_province = SalesTax.all
  end

  def create
    @user = User.new(user_params)

    if @user.save
      Order.create(user_id: @user.id,
                   movie_id: session[:movies_in_cart][0].first.to_i,
                   total: (session[:subtotal].first.to_f * (1 + session[:PST].to_f + session[:GST].to_f)).round(2),
                   quantity: session[:movies_in_cart][1].first.to_i)

      customer = Stripe::Customer.create(
        :email => @user.email,
        :source  => params[:stripeToken]
      )

      charge = Stripe::Charge.create(
        :customer    => customer.id,
        :amount      => ((session[:subtotal].first.to_f * (1 + session[:PST].to_f + session[:GST].to_f)).round(2) * 100).round(),
        :description => 'Rails Stripe customer',
        :currency    => 'usd'
      )

      session[:movies_in_cart][0] = []
      session[:movies_in_cart][1] = []
      session[:subtotal] = []

      redirect_to index_path
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
