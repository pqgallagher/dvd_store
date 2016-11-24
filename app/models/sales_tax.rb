class SalesTax < ApplicationRecord
  validates :province, :gst,  presence: true
end
