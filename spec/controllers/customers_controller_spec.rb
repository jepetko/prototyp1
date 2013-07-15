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
      end
    end

  end



end