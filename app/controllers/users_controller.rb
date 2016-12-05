class UsersController < ApplicationController
  # Sets the class variables to all the values in the session variables
  before_action :load, only: [:index]

  def index
    # If the user is logged in loads the form
    # with ther customer info.
    if session[:login].present?
      @user_order = User.find(session[:login])
    else
      @user_order = User.new
    end
    # Sets the class variable to the data from the database.
    @sales_tax_by_province = SalesTax.all
  end

  def create
    # Sets the class variables to all the values in the session variables
    @movies_in_cart = Movie.find(session[:movies_in_cart][0])
    @pst = session[:PST]

    # If the user is logged in sets the user object
    # to thier database info.
    if session[:login].present?
      @user_order = User.find(session[:login])
    else
      # Creates a new user object.
      @user_order = User.new(user_params)
    end

    # If the user selected create account.
    if params[:user_create]
      # Sets the password and sets the user as registered.
      @user_order.password = params[:password]
      @user_order.registered = true
    end

    # If the user info was saved.
    if @user_order.save

      # Creates a stripe customer.
      customer = Stripe::Customer.create(
        :email => @user_order.email,
        :source  => params[:stripeToken]
      )

      # Charges the stripe customer.
      charge = Stripe::Charge.create(
        :customer    => customer.id,
        :amount      => ((sum_session(session[:subtotal]).round(2) * (1 + session[:PST].to_f + session[:GST].to_f)).round(2) * 100).round(),
        :description => 'Rails Stripe customer',
        :currency    => 'usd'
      )

      # If the payment has gone through.
      if charge.paid
        # Creates a new customer order.
        @order = Order.create(user_id: @user_order.id,
                              total: (sum_session(session[:subtotal]).round(2) * (1 + session[:PST].to_f + session[:GST].to_f)).round(2),
                              pst: @pst)

        # Adds all the movies in the cart to the Movie Order table
        # associates the Movie Order with the order created in the Order table.
        @movies_in_cart.each_with_index do |item, x|
          MovieOrder.create(order_id: @order.id,
                            movie_id: item.id,
                            price: item.price,
                            quantity: session[:movies_in_cart][1][x])
        end
      end

      # Removes all movies from the cart by
      # clearing all the sessions.
      session[:movies_in_cart][0] = []
      session[:movies_in_cart][1] = []
      session[:subtotal] = []

      redirect_to index_path
    else
      load
      render :index
    end
  end

  # Sums the values of the array passed in.
  def sum_session(amount)
    total = 0
    amount.each do |num|
      total += num.to_f
    end
    return total
  end

  private
  # Sets the class variables to all the values in the session variables
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

  # Sets the params for the various forms.
  def user_params
    params.require(:user).permit(:fname, :lname, :address, :pcode, :email, :username, :password)
  end
end
