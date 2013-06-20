Prototyp1::Application.routes.draw do
  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"
  resources :users
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
end