require 'spec_helper'

describe CustomersController do

  render_views

  before(:all) do
    @selector_for_blank_hint = '//*[text()="' + I18n.t('activerecord.errors.messages.blank') + '"]'
  end

  describe 'When user is not eligible to see any customers because he is not logged in' do

    before(:each) do
      login_set_user_seed([:customer,:company_avatar],true)
    end

    it "doesn't list any customers" do
      get :index
      response.should redirect_to('/users/sign_in')
    end

    it "doesn't return a single customer" do
      get :show, :id => @test_customer.id
      response.should redirect_to('/users/sign_in')
    end
  end

  describe 'When user is logged in' do

    before(:each) do

      login_set_user_seed([:customer])

      @c_attr = {
          name: 'Customer Ltd.',
          street: 'Example Str.',
          city: 'New York',
          zip: 11111,
          country: 'United States',
          latlon: 'POINT(1 1)'
      }
      @c_attr_failure = {
          name: 'Test'
      }
    end

    describe 'routing' do

      it 'routes to #index' do
        { :get => '/customers'}.should \
          route_to(:controller => 'customers', :action => 'index')
      end

      it 'routes to #new' do
        { :get => '/customers/new' }.should \
          route_to(:controller => 'customers', :action => 'new')
      end

      it 'routes to #create' do
        { :post => '/customers'}.should \
          route_to(:controller => 'customers', :action => 'create')
      end

      it 'routes to #show' do
        { :get => "/customers/#{@test_customer.id}" }.should \
          route_to(:controller => 'customers', :action => 'show', :id => @test_customer.id.to_s)
      end

      it 'routes to #edit' do
        { :get => "/customers/#{@test_customer.id}/edit" }.should \
          route_to(:controller => 'customers', :action => 'edit', :id => @test_customer.id.to_s)
      end

      it 'routes to #update' do
        { :put => "/customers/#{@test_customer.id}" }.should \
          route_to(:controller => 'customers', :action => 'update', :id => @test_customer.id.to_s)
      end

      it 'routes to #destroy' do
        { :delete => "/customers/#{@test_customer.id}" }.should \
          route_to(:controller => 'customers', :action => 'destroy', :id => @test_customer.id.to_s)
      end
    end

    describe "get 'index'" do
      before(:each) do
        FactoryGirl.create(:customer, name: 'I am a new customer', latlon: 'POINT(16.344 48.185)')
        @geom = 'POLYGON((16.343390733776932 48.18425220210939,16.343390733776932 48.190861439574796,16.3574240513432 48.190861439574796,16.3574240513432 48.18425220210939,16.343390733776932 48.18425220210939))'
      end

      it 'is successful' do
        get :index
        response.should have_selector('div', :class => 'thumbnail customer', :count => Customer.all.length)
      end

      it 'is successful when passing a keyword' do
        get :index, :keyword => 'customer'
        response.should be_success
        response.should have_selector('div', :class => 'thumbnail customer', :count => 1) do |div|
          div.to_html.should =~ /I am a new customer/
        end
      end

      it 'is successful when passing a geometry' do
        get :index, :geom => @geom
        response.should be_success
        response.should have_selector('div', :class => 'thumbnail customer', :count => 1) do |div|
          div.to_html.should =~ /I am a new customer/
        end
      end
    end

    describe "get 'new'" do
      it 'is successful' do
        get :new
        response.should be_success
        response.should have_selector('input', :id => 'customer_name')
        response.should have_selector('input', :id => 'customer_street')
        response.should have_selector('input', :id => 'customer_zip')
        response.should have_selector('input', :id => 'customer_city')
        response.should have_selector('input', :type => 'submit')

        response.should have_selector('.fileupload-buttonbar')
      end
    end

    describe "post 'create'" do

      it 'is successful' do
        expect {
          post :create, customer: @c_attr
          flash[:notice].should eq( I18n.t('views.company.flash_messages.created_successfully'))
        }.to change(Customer,:count).by(1)
      end

      it 'is failure' do
        expect {
          post :create, customer: @c_attr_failure
          response.should render_template(:new)

          ## note: 4 'blank' hints must be shown because of missing city, zip, street and country
          response.should have_selector( @selector_for_blank_hint, :count => 5 )
        }.not_to change(Customer,:count)
      end
    end

    describe "get 'edit'" do

      it 'is successful' do
        get :edit, id: @test_customer.id
        response.should be_success

        {'input#customer_name' => @test_customer.name,
         'input#customer_city' => @test_customer.city,
         'input#customer_street' => @test_customer.street,
         'input#customer_zip' => @test_customer.zip}.each do |k,v|

          response.should have_selector(k, :value => v)
        end

        response.should have_selector('select#customer_country') do |select|
          select.should have_selector('option', :value => @test_customer.country)
        end

        response.should contain('<tr class="template-download fade"')  #company avatar
      end

      it 'is failure' do
        expect {
          get :edit, id: 1000
          response.should_not be_success
        }.to raise_error ActiveRecord::RecordNotFound
      end

    end

    describe 'put :update' do

      it "is successful when changing records' data" do
        #we change the city value
        new_customer = @test_customer.attributes.except('id','updated_at','created_at').merge('city' => 'New York')

        put :update, :id => @test_customer.id, :customer => new_customer
        @test_customer.reload
        @test_customer.city.should eq(new_customer['city'])
        response.should redirect_to( customer_path(@test_customer) )
        flash[:notice].should eq( I18n.t('views.company.flash_messages.updated_successfully') )
      end

      it 'is failure when passing invalid values' do
        #we change the city value (blank)
        new_customer = @test_customer.attributes.except('id','updated_at','created_at').merge('city' => '')

        put :update, :id => @test_customer.id, :customer => new_customer
        response.should render_template('edit')
        response.should have_selector( @selector_for_blank_hint, :count => 1)
      end

    end

    describe 'delete :destroy' do

      it 'is successful when passing existing customer' do
        expect {
          delete :destroy, :id => @test_customer.id
          response.should redirect_to( customers_path )
        }.to change(Customer,:count).by(-1)
      end

      it 'is failure when passing not existing customer' do
        expect {
          delete :destroy, :id => 1000
        }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end