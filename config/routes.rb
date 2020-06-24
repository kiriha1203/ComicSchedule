Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks', registrations: 'users/registrations', sessions: 'users/sessions' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'books#index'

  resources :users, only: %i[show]

  namespace :admin do
    resources :books, shallow: true do
      get :new_index, on: :collection
    end
    resources :book_details, shallow: true do
      get :new_index, on: :collection
    end
  end

  resources :books, shallow: true do
    get :bookmarks_index, on: :collection
    resource :bookmarks, only: %i[create destroy]
    get :bookmarks, on: :collection
  end

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
end

