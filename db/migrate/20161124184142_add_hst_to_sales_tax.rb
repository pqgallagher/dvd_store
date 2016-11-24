class AddHstToSalesTax < ActiveRecord::Migration[5.0]
  def change
    add_column :sales_taxes, :hst, :decimal
  end
end
