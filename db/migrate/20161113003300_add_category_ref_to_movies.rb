class AddCategoryRefToMovies < ActiveRecord::Migration[5.0]
  def change
    add_reference :movies, :id, foreign_key: true
  end
end
