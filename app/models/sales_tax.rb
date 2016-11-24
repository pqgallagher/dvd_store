class SalesTax < ApplicationRecord
  validates :province, :rate,  presence: true
end
