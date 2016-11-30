class Movie < ApplicationRecord
  validates :title, :content, :picture, :category_id, :price,  presence: true
  mount_uploader :avatar, AvatarUploader
  belongs_to :category
end
