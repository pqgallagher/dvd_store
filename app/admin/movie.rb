ActiveAdmin.register Movie do
  permit_params :title, :content, :picture, :genre, :category_id
end
