Prototyp1::Application.routes.draw do

  resources :company_avatars, :only => [:create, :destroy, :show]

  resources :customers
  resources :customers do

    resources :contacts, :only => [:new, :create, :destroy, :index, :edit_all, :update]

  end

  match '/customers/:customer_id/edit/contacts' => 'contacts#edit_all', :via => :get, :as => 'edit_all_customer_contacts'

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

  #match '*a', :to => 'errors#routing'
end