ActiveAdmin.register Order do
  permit_params :user_id, :movie_id, :total, :quantity
end
