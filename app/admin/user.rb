ActiveAdmin.register User do
  permit_params :registered, :fname, :lname, :address, :pcode, :email
end
