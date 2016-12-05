class ContactsController < ApplicationController
  # Sets the class variable to the values from the database.
  def index
    @contact = Contact.first
  end
end
