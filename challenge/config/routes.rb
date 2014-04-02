Challenge::Application.routes.draw do
  root 'purchases#index'

  resources :purchases, only: [:index] do
    collection do
      get :select_file
      post :import
    end
  end
end
