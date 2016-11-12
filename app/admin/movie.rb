ActiveAdmin.register Movie do
  permit_params :title, :content, :picture, :genre
end
