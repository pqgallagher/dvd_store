class AddNewToMovies < ActiveRecord::Migration[5.0]
  def change
    add_column :movies, :new, :boolean
  end
end
