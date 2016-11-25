class AddSaleToMovies < ActiveRecord::Migration[5.0]
  def change
    add_column :movies, :sale, :boolean
  end
end
