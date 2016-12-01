class ContactsController < ApplicationController
  def index
    @contact = Contact.first
  end
end
