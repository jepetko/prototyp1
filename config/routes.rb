Prototyp1::Application.routes.draw do

  match '/customers/map' => 'customers#map', :via => :get, :as => 'show_all_customers_in_map'

  resources :customers

  #resources :layers, :only => [:index]

  scope module: 'maps' do
    resources :layers, :only => [:index]
    resources :tools, :only => [:index]
  end

  resources :company_avatars, :only => [:create,:show,:destroy]  #show, destroy

  resources :customers do
    resources :company_avatars, :only => [:destroy, :show, :create]
    resources :contacts, :only => [:new, :create, :destroy, :index, :edit_all, :update, :form]
  end

  match '/customers/:customer_id/edit/contacts' => 'contacts#edit_all', :via => :get, :as => 'edit_all_customer_contacts'

  match '/customers/:customer_id/contacts/:id/form' => 'contacts#form', :via => :get, :as => 'form_customer_contact'

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