ActiveAdmin.register Contact do
  permit_params :address, :hours, :phone, :email
end
