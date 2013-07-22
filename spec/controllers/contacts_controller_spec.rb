require 'spec_helper'

describe ContactsController do

  render_views

  describe 'if user is not eligible' do

    before(:each) do
      login_set_user_seed([:customer, :company_avatar, :contact], true)
    end

    it 'should redirect to login when user requests the list of contacts' do
      get :index, :customer_id => @test_customer.id
      response.should redirect_to('/users/sign_in')
    end

  end

  describe 'if user is eligible' do

    before(:each) do
      login_set_user_seed([:customer,:company_avatar,:contact])
    end

    describe "routing" do

      it "routes to nested #new for the specified customer"  do
        { :get => "/customers/#{@test_customer.id}/contacts/new" }.should \
          route_to(:controller => 'contacts', :action => 'new', :customer_id => @test_customer.id.to_s)
      end

      it "routes to nested #create if contact is created for a customer" do
        { :post => "/customers/#{@test_customer.id}/contacts" }.should \
          route_to(:controller => 'contacts', :action => 'create', :customer_id => @test_customer.id.to_s)
      end

      it "routes to #index" do
        { :get => "/customers/#{@test_customer.id}/contacts" }.should \
          route_to(:controller => 'contacts', :action => 'index', :customer_id => @test_customer.id.to_s)
      end

      it "routes to nested #destroy if contact is associated with a customer" do
        { :delete => "/customers/#{@test_customer.id}/contacts/#{get_last_contact_id_of_test_cust}" }.should \
          route_to(:controller => 'contacts', :action => 'destroy', :customer_id => @test_customer.id.to_s, :id => get_last_contact_id_of_test_cust)
      end

      it "routes to nested #update if contact is associated with a customer" do
        { :put => "/customers/#{@test_customer.id}/contacts/#{get_last_contact_id_of_test_cust}"}.should \
          route_to(:controller => 'contacts', :action => 'update', :customer_id => @test_customer.id.to_s, :id => get_last_contact_id_of_test_cust)
      end

      it "routes to #edit_all" do
        { :get => "/customers/#{@test_customer.id}/edit/contacts" }.should \
          route_to(:controller => 'contacts', :action => 'edit_all', :customer_id => @test_customer.id.to_s)
      end

      ####################################
      ### not routable:

      it "doesn't route to #show" do
        { :get => "/customers/#{@test_customer.id}/contacts/#{get_last_contact_id_of_test_cust}" }.should_not \
          be_routable
      end

      it "doesn't route to #edit for a single edit (see edit_all method)" do
        { :get => "/customers/#{@test_customer.id}/contacts/#{get_last_contact_id_of_test_cust}/edit"}.should_not \
          be_routable
      end
    end
  end

end
