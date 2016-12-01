class Order < ApplicationRecord
  validates :user_id, :total, :pst, presence: true
end
