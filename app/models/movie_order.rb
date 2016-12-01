class MovieOrder < ApplicationRecord
  validates :order_id, :movie_id, :price, :quantity, presence: true
end
