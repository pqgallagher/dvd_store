class Movie < ApplicationRecord
  validates :title, :content, :picture, :category_id, :price,  presence: true
  belongs_to :category
end
