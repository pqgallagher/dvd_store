class LoginController < ApplicationController
  before_action :initialize_session
  def index
  end

  def authenticate
    # redirect_to index_path
    redirect_to login_path
  end

  def initialize_session
    session[:login] ||= []
  end
end
