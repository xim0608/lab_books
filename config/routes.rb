Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "welcome#index"

  devise_for :users,
             skip: [:session, :registration],
             controllers: {omniauth_callbacks: "users/omniauth_callbacks",
                            registrations: "users/registrations",
                            sessions: "users/sessions"
  }
  devise_scope :user do
    post '/users/sign_in' => 'devise/sessions#create', as: :user_session
    delete '/users/sign_out' => 'devise/sessions#destroy', as: :destroy_user_session
    post '/users' => 'users/registrations#create', as: :user_registration
    get '/users/edit' => 'users/registrations#edit', as: :edit_user_registration
    patch '/users' => 'users/registrations#update', as: nil
    put '/users' => 'users/registrations#update', as: :update_user_registration
    delete '/users' => 'users/registrations#destroy', as: :destroy_user_registration
  end


  resources :books, except: [:edit, :update, :delete] do
    collection do
      get :import_from_csv
      post :import
      post :rent
      post :return
    end
  end
end
