class RemoveDateFromMovies < ActiveRecord::Migration[5.0]
  def change
    remove_column :movies, :date, :datetime
  end
end
