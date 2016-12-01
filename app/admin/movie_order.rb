ActiveAdmin.register MovieOrder do
  permit_params :order_id, :movie_id, :price, :quantity
end
