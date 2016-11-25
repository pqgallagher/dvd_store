class User < ApplicationRecord
  validates :fname, :lname, :address,:pcode,:email, presence: true
end
