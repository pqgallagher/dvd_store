class User < ApplicationRecord
  validates :fname, :lname, :address,:pcode,:email, presence: true
  attr_encrypted :password, key: 'tak3453449000gntksuht3464hygbijskj'
end
