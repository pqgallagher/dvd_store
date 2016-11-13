class RemoveUpdatedFromMovies < ActiveRecord::Migration[5.0]
  def change
    remove_column :movies, :updated, :datetime
  end
end
