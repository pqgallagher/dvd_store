class Movie < ApplicationRecord
  validates :title, :content, :picture, :category_id,  presence: true
  belongs_to :category
end
