Challenge::Application.routes.draw do
  devise_for :users
  root 'uploads#new'

  resources :uploads, only: [:new, :create, :show]
end
