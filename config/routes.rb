Rails.application.routes.draw do

  devise_for :users

  # token auth routes available at /api/auth/
  namespace :api, defaults: { format: :json } do
    scope module: :v1 do
      mount_devise_token_auth_for 'User', at: 'auth'
    end
  end
  #mount_devise_token_auth_for 'User', at: 'auth'
  resources :courses
  #get 'courses/list'
  #devise_for :users
  #get 'sessions/new'
  #get 'sessions/create'
  #get 'sessions/login'
  #get 'sessions/welcome'
  #get 'users/new'
  #get 'users/create'
  #get 'home/index'
  root 'home#index'
  post 'courses/enroll'
  post 'courses/deenroll'
  post 'courses/list'
  post 'courses/enrollments'
  get 'home/mycourses'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
