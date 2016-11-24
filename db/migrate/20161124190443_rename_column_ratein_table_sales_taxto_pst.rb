class RenameColumnRateinTableSalesTaxtoPst < ActiveRecord::Migration[5.0]
  def change
    rename_column :sales_taxes, :rate, :pst
  end
end
