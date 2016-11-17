Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # GET / loads the index action of the tasks controller
  root 'movies#index', as: 'index'
  get 'movies/:id' => 'movies#show', as: 'movie', id: /\d+/

  resources :movies, only: [:index] do
    member do
      post :add_to_cart
      post :remove_from_cart
      post :sort
      post :search
    end
    collection do
      post :remove_all
      post :show_all
    end
  end

end
