require "spec_helper"

describe CompanyAvatarsController do
  describe "routing" do

    it "routes to #index" do
      get("/company_avatars").should route_to("company_avatars#index")
    end

    it "routes to #new" do
      get("/company_avatars/new").should route_to("company_avatars#new")
    end

    it "routes to #show" do
      get("/company_avatars/1").should route_to("company_avatars#show", :id => "1")
    end

    it "routes to #edit" do
      get("/company_avatars/1/edit").should route_to("company_avatars#edit", :id => "1")
    end

    it "routes to #create" do
      post("/company_avatars").should route_to("company_avatars#create")
    end

    it "routes to #update" do
      put("/company_avatars/1").should route_to("company_avatars#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/company_avatars/1").should route_to("company_avatars#destroy", :id => "1")
    end

  end
end
