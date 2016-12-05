class UsersController < ApplicationController
  before_action :load, only: [:index]

  def index
    if session[:login].present?
      @user_order = User.find(session[:login])
    else
      @user_order = User.new
    end

    @sales_tax_by_province = SalesTax.all
  end

  def create

    if session[:login].present?
      @user_order = User.find(session[:login])
    else
      @user_order = User.new(user_params)
    end

    if params[:user_create]
      @user_order.password = params[:password]
      @user_order.registered = true
    end

    @movies_in_cart = Movie.find(session[:movies_in_cart][0])
    @pst = session[:PST]

    if @user_order.save
      customer = Stripe::Customer.create(
        :email => @user_order.email,
        :source  => params[:stripeToken]
      )

      charge = Stripe::Charge.create(
        :customer    => customer.id,
        :amount      => ((sum_session(session[:subtotal]).round(2) * (1 + session[:PST].to_f + session[:GST].to_f)).round(2) * 100).round(),
        :description => 'Rails Stripe customer',
        :currency    => 'usd'
      )

      if charge.paid
        @order = Order.create(user_id: @user_order.id,
                              total: (sum_session(session[:subtotal]).round(2) * (1 + session[:PST].to_f + session[:GST].to_f)).round(2),
                              pst: @pst)

        @movies_in_cart.each_with_index do |item, x|
          MovieOrder.create(order_id: @order.id,
                            movie_id: item.id,
                            price: item.price,
                            quantity: session[:movies_in_cart][1][x])
        end
      end

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
    @user = session[:login]
  end

  def user_params
    params.require(:user).permit(:fname, :lname, :address, :pcode, :email, :username, :password)
  end
end
