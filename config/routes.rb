TaskManager::Application.routes.draw do
  get "logout" => "sessions#destroy", :as => "logout"
  get "login" => "sessions#new", :as => "login"
  get "register" => "users#index", :as => "register"
  root :to => "stories#index"
  resources :users
  resources :stories
  resources :sessions
  resources :comments
end
