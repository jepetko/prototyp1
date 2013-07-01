Prototyp1::Application.routes.draw do

  resources :company_avatars, :only => [:create, :destroy, :show]

  resources :customers
  resources :customers do
    resources :contacts
  end

  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  resources :users

  #for unknown error catchment
  devise_scope :user do
    get "/users/auth/failure" => "users/omniauth_callbacks#failure"
  end
end