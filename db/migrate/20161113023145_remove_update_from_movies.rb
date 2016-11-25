class RemoveUpdateFromMovies < ActiveRecord::Migration[5.0]
  def change
    remove_column :movies, :update, :datetime
  end
end
