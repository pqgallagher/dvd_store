class LoginController < ApplicationController
  before_action :initialize_session
  # Sets the class variables to all the values in the session variables
  before_action :load, only: [:index]

  def index
    # Clears any form errors if there are any.
    session[:error] = 0
    # If the user is already logged in they are sent
    # to the index.
    if session[:login].present?
      redirect_to index_path
    end
  end

  def authenticate
    # Clears any form errors if there are any.
    session[:error] = 0

    # If the user has put values in the username and password field.
    if params[:user_name].present? && params[:password].present?
      # Gets the password from the database based on the username given by the user.
      password_db = User.where(username: params[:user_name])
      # Sets to the password provided by the user.
      password_input = params[:password]

      # If the databse query based on user name, does not come back with a password.
      if password_db.first.nil?
        # Displays 'Incorrect User Name and Password Combination' Error.
        session[:error] = 2
        redirect_to login_path
      # If the password from the database and the password the user provided match.
      elsif password_db.first.password == password_input
        session[:login] = password_db.first.id
        redirect_to :back
      # If the password the user provided does not match the password in the database.
      else
        # Displays 'Incorrect User Name and Password Combination' Erro
        session[:error] = 2
        redirect_to login_path
      end
    # If the user puts no data in the inputs.
    else
      # Please enter a value into User Name and Password
      session[:error] = 1
      redirect_to login_path
    end
  end

  private
  def initialize_session
    session[:login] ||= []
    session[:error] ||= []
  end
  # Sets the class variable to the value in the session variable.
  def load
    @error = session[:error]
  end
end
