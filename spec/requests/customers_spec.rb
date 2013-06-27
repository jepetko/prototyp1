require 'spec_helper'

describe "Customers" do

  describe "user not authenticated" do

    describe "GET /customers" do
      it "redirects to login" do
        # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
        get customers_path
        response.should redirect_to('/users/sign_in')
      end
    end

  end

  describe "user autenticated" do

    before(:each) do
      user = FactoryGirl.create(:user, email: FactoryGirl.generate(:email))
      visit 'users/sign_in'
      fill_in :email, :with => user.email
      fill_in :password, :with => user.password
      click_button
    end

    describe "GET /customers" do

      before(:each) do
        10.times do
          c = FactoryGirl.create(:customer)
        end
      end

      it "lists all customers" do
        # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
        get customers_path
        response.status.should be(200)
        response.should have_selector('.customer', :count => 10) do |c|
          c.should have_selector('.pic')
        end
      end

    end

    describe "GET /customer/N" do
      before(:each) do
        @customer = FactoryGirl.create(:customer)
      end

      it "returns the customer" do
        get "/customers/#{@customer.id}"
        response.status.should be(200)
        response.should contain(@customer.name)
      end
    end

  end


end
