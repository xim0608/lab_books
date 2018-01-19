Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "welcome#index"

  devise_scope :user do
    get '/sign_in' => 'devise/sessions#new'
  end

  # disable sign_up from top_page
  devise_for :users, skip: [:registrations], controllers: {invitations: 'users/invitations', passwords: 'users/passwords'}
  as :user do
    get 'users/edit' => 'users/registrations#edit', :as => 'edit_user_registration'
    put 'users' => 'users/registrations#update', :as => 'user_registration'
    get 'users/:id/favorites' => 'favorites#index', :as => 'user_favorite_books'
  end

  namespace :api do
    mount_devise_token_auth_for 'User',
                                at: 'auth',
                                skip: [:registrations, :passwords, :invitations],
                                controllers: {
                                    sessions: 'api/auth/sessions'
                                }
    resources :books, only: [:index]
    resources :rentals, only: [:index, :create]
  end
  post 'user_token' => 'user_token#create'

  resources :books, except: [:edit, :update, :delete] do
    collection do
      get :search
      get :import_from_csv
      post :import
      post :show_review
      post :change_show_type
      post :change_show_num
    end
    member do
      get :recommends
      get :favorites, to: 'favorites#show_cliped_users'
    end
  end

  resources :admins, only: [:index] do
    collection do
      get :users
      get 'users/:user_id', to: 'admins#show', as: 'user'
      get 'users/:user_id/:book_id', to: 'admins#change_flag', as: 'admin_change_rental_flag'
    end
  end

  get 'api/inc_search', to: 'api#inc_search'
  post 'api/process', to: 'api#data_catcher'
  get 'api/rentals/:student_id', to: 'rentals#show_by_student_id'
  get 'api/rentals/change_flag/:student_id', to: 'rentals#change_unread_flag', as: 'rental_change_unread_flag'
  get 'api/check_book/:book_isbn', to: 'api#check_book'
  get 'rentals/:user_id', to: 'rentals#show', as: 'user_rental'

  resources :favorites, only: [:destroy, :create]

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
