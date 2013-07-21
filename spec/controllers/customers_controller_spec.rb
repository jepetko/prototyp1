require 'spec_helper'

describe CustomersController do

  render_views

  before(:all) do
    @selector_for_blank_hint = '//*[text()="' + I18n.t('activerecord.errors.messages.blank') + '"]'
  end

  describe "When user is not eligible to see any customers because he is not logged in" do

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

  describe "When user is logged in" do

    before(:each) do

      login_set_user_seed([:customer])

      @c_attr = {
          name: 'Customer Ltd.',
          street: 'Example Str.',
          city: 'New York',
          zip: 11111,
          country: 'United States'
      }
      @c_attr_failure = {
          name: 'Test'
      }
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

      it "is successful" do
        expect {
          post :create, customer: @c_attr
          flash[:notice].should eq( I18n.t('views.company.flash_messages.created_successfully'))
        }.to change(Customer,:count).by(1)
      end

      it "is failure" do
        expect {
          post :create, customer: @c_attr_failure
          response.should render_template(:new)

          ## note: 4 'blank' hints must be shown because of missing city, zip, street and country
          response.should have_selector( @selector_for_blank_hint, :count => 4 )
        }.not_to change(Customer,:count)
      end
    end

    describe "get 'edit'" do

      it "is successful" do
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

      it "is failure" do
        expect {
          get :edit, id: 1000
          response.should_not be_success
        }.to raise_error ActiveRecord::RecordNotFound
      end

    end

    describe "put :update" do

      it "is successful when changing records' data" do
        #we change the city value
        new_customer = @test_customer.attributes.except('id','updated_at','created_at').merge('city' => 'New York')

        put :update, :id => @test_customer.id, :customer => new_customer
        @test_customer.reload
        @test_customer.city.should eq(new_customer['city'])
        response.should redirect_to( customer_path(@test_customer) )
        flash[:notice].should eq( I18n.t('views.company.flash_messages.updated_successfully') )
      end

      it "is failure when passing invalid values" do
        #we change the city value (blank)
        new_customer = @test_customer.attributes.except('id','updated_at','created_at').merge('city' => '')

        put :update, :id => @test_customer.id, :customer => new_customer
        response.should render_template('edit')
        response.should have_selector( @selector_for_blank_hint, :count => 1)
      end

    end

    describe "delete :destroy" do

      it "is successful when passing existing customer" do
        expect {
          delete :destroy, :id => @test_customer.id
          response.should redirect_to( customers_path )
        }.to change(Customer,:count).by(-1)
      end

      it "is failure when passing not existing customer" do
        expect {
          delete :destroy, :id => 1000
        }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end