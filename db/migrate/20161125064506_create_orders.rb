class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.integer :user_id
      t.integer :movie_id
      t.decimal :total
      t.integer :quantity

      t.timestamps
    end
  end
end
