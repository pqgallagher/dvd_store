ActiveAdmin.register Movie do
  permit_params :title, :content, :picture, :category_id
end
