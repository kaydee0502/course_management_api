Rails.application.routes.draw do
  resources :courses
  #get 'courses/list'
  devise_for :users
  #get 'sessions/new'
  #get 'sessions/create'
  #get 'sessions/login'
  #get 'sessions/welcome'
  #get 'users/new'
  #get 'users/create'
  #get 'home/index'
  root 'home#index'
  post 'courses/enroll'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
