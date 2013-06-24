require 'spec_helper'

describe CustomersController do

  before(:each) do
    @user = FactoryGirl.create(:user)
    test_log_in(@user)
    [0..10].each do
      FactoryGirl.create(:customer)
    end
    @test_customer_id = Customer.last
    test_log_out(@user)
  end

  describe 'When there is no current user' do

    it "doesn't list any customers" do
      get :index
      response.should redirect_to('/users/sign_in')
    end

    it "doesn't return a single customer" do
      get :show, :id => @test_customer_id
      response.should redirect_to('/users/sign_in')
    end
  end

end