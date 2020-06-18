Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks'}
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'books#index'

  resources :books, shallow: true do
    resource :bookmarks, only: %i[create destroy]
    get :bookmarks, on: :collection
  end
end
