class SalesTax < ApplicationRecord
  validates :province, :rate, :gst,  presence: true
end
