class Order < ApplicationRecord
  validates :user_id, :total, presence: true
end
