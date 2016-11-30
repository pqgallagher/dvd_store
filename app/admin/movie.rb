ActiveAdmin.register Movie do
  permit_params :title, :content, :category_id, :price, :sale, :new, :avatar
end
