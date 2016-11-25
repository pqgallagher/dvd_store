class User < ApplicationRecord
  validates :registered, :fname, :lname, :address,:pcode,:email, presence: true
end
