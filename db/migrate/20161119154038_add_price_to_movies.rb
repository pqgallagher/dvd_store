class AddPriceToMovies < ActiveRecord::Migration[5.0]
  def change
    add_column :movies, :price, :decimal
  end
end
