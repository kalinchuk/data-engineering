Challenge::Application.routes.draw do
  devise_for :users
  root 'purchases#index'

  resources :purchases, only: [:index] do
    collection do
      post :import
    end
  end
end
