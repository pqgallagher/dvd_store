class Order < ApplicationRecord
  validates :user_id, :movie_id, :total, :quantity, presence: true
end
