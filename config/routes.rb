Rails.application.routes.draw do
  resources :books, only: [:index]

  # devise_for :users,
  #            :controllers => {omniauth_callbacks: "users/omniauth_callbacks",
  #                             registrations: "users/registrations",
  #                             sessions: "users/sessions"
  #            }

  devise_scope :user do
    post '/users/sign_in' => 'devise/sessions#create', as: :user_session
    delete '/users/sign_out' => 'devise/sessions#destroy', as: :destroy_user_session
    post '/users' => 'users/registrations#create', as: :user_registration
    get '/users/edit' => 'users/registrations#edit', as: :edit_user_registration
    patch '/users' => 'users/registrations#update', as: nil
    put '/users' => 'users/registrations#update', as: :update_user_registration
    delete '/users' => 'users/registrations#destroy', as: :destroy_user_registration
    match '/users/auth/slack/callback' => 'users/omniauth_callbacks#slack', as: :user_slack_omniauth_callback, via: [:get, :post]
    match '/users/auth/slack' => 'users/omniauth_callbacks#passthru', as: :user_slack_omniauth_authorize, via: [:get, :post]
  end


  root to: "welcome#index"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
