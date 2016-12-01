class UsersController < ApplicationController
  before_action :load, only: [:index]

  def index
    @user = User.new
    @sales_tax_by_province = SalesTax.all
  end

  def create
    @user = User.new(user_params)
    @movies_in_cart = Movie.find(session[:movies_in_cart][0])
    @pst = session[:PST]

    if @user.save
      customer = Stripe::Customer.create(
        :email => @user.email,
        :source  => params[:stripeToken]
      )

      charge = Stripe::Charge.create(
        :customer    => customer.id,
        :amount      => ((sum_session(session[:subtotal]).round(2) * (1 + session[:PST].to_f + session[:GST].to_f)).round(2) * 100).round(),
        :description => 'Rails Stripe customer',
        :currency    => 'usd'
      )

      if charge.paid
        @order = Order.create(user_id: @user.id,
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
  end

  def user_params
    params.require(:user).permit(:fname, :lname, :address, :pcode, :email)
  end
end
