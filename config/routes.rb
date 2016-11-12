Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  #GET / loads the index action of the tasks controller
  root 'movies#index'
  get 'movies/:id' => 'movies#show', as: 'movie', id: /\d+/
end
