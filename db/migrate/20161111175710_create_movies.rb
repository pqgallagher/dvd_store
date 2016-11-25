class CreateMovies < ActiveRecord::Migration[5.0]
  def change
    create_table :movies do |t|
      t.string :title
      t.text :content
      t.string :picture
      t.string :genre
      t.datetime :date
      t.datetime :updated

      t.timestamps
    end
  end
end
