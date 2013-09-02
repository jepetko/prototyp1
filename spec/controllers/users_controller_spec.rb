require 'spec_helper'

describe UsersController do

  before (:each) do
    @test_user = FactoryGirl.create(:user)
    sign_in @test_user
  end

  describe "GET 'show'" do
    
    it "should be successful" do
      get :show, :id => @test_user.id
      response.should be_success
    end
    
    it "should find the right user" do
      get :show, :id => @test_user.id
      assigns(:user).should == @test_user
    end
    
  end

end
