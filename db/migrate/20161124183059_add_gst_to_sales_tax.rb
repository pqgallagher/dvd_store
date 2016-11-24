class AddGstToSalesTax < ActiveRecord::Migration[5.0]
  def change
    add_column :sales_taxes, :gst, :decimal
  end
end
