Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # GET / loads the index action of the tasks controller
  root 'movies#index', as: 'index'
  get 'movies/:id' => 'movies#show', as: 'movie', id: /\d+/
  get 'users' => 'users#index', as: 'user'
  post 'users' => 'users#create'
  get 'contacts' => 'contacts#index', as: 'contact'
  get 'abouts' => 'abouts#index', as: 'about'
  get 'login' => 'login#index', as: 'login'
  post 'login' => 'login#authenticate', as: 'auth'

  resources :charges

  resources :movies, only: [:index] do
    member do
      post :add_to_cart
      post :remove_from_cart
      post :update_quantity
      post :search
      post :sale_new

    end
    collection do
      post :remove_all
      post :show_all
      post :set_pst
      post :reset_pst
      post :logout
    end
  end

end
