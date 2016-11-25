class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.boolean :registered
      t.string :fname
      t.string :lname
      t.string :address
      t.string :pcode
      t.string :email

      t.timestamps
    end
  end
end
