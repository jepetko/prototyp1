require 'spec_helper'

describe CustomersController do

  render_views

  describe "When user is not eligible to see any customers because he is not logged in" do

    before(:each) do
      @user = FactoryGirl.create(:user)
      test_log_in(@user)
      [0..10].each do
        FactoryGirl.create(:customer)
      end
      @test_customer_id = Customer.last
      test_log_out(@user)
    end

    it "doesn't list any customers" do
      get :index
      response.should redirect_to('/users/sign_in')
    end

    it "doesn't return a single customer" do
      get :show, :id => @test_customer_id
      response.should redirect_to('/users/sign_in')
    end
  end

  describe "When user is logged in" do

    before(:each) do
      @user = FactoryGirl.create(:user)
      test_log_in(@user)
      [0..10].each do
        FactoryGirl.create(:customer)
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
      end
    end

    describe "post 'create'" do

      before(:each) do
        @c_attr = {
            name: 'Customer Ltd.',
            street: 'Example Str.',
            city: 'New York',
            zip: 11111,
            country: 'USA'
        }
      end

      it "is successful" do
        post :create, customer: @c_attr
        flash[:notice].should be( I18n.t('created'))
      end

=begin
      describe "creating records by filling values into the fields" do


        it "is successful" do
          get :new
          fill_in :customer_name, @c_attr['name']
          fill_in :customer_street, @c_attr['street']
          fill_in :customer_city, @c_attr['city']
          fill_in :customer_zip, @c_attr['zip']
          choose :customer_country, @c_attr['country']
          click_button
          response.should

        end

      end
=end

    end

  end



end