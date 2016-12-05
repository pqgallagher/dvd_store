class LoginController < ApplicationController
  before_action :initialize_session
  before_action :load, only: [:index]

  def index
    session[:error] = 0
    if session[:login].present?
      redirect_to index_path
    end
  end

  def authenticate
    session[:error] = 0
    if params[:user_name].present? && params[:password].present?
      password_db = User.where(username: params[:user_name])
      password_input = params[:password]


      if password_db.first.nil?
        session[:error] = 2
        redirect_to login_path
      elsif password_db.first.password == password_input
        session[:login] = password_db.first.id
        redirect_to :back
      else
        session[:error] = 2
        redirect_to login_path
      end
    else
      session[:error] = 1
      redirect_to login_path
    end
  end

  private
  def initialize_session
    session[:login] ||= []
    session[:error] ||= []
  end

  def load
    @error = session[:error]
  end
end
