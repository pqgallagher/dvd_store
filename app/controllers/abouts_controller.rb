class AboutsController < ApplicationController
  # Sets the class variable to the values from the database.
  def index
    @about = About.first
  end
end
