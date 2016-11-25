class CreateSalesTaxes < ActiveRecord::Migration[5.0]
  def change
    create_table :sales_taxes do |t|
      t.string :province
      t.decimal :rate

      t.timestamps
    end
  end
end
