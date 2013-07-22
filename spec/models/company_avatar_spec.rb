require 'spec_helper'
require 'paperclip'

describe CompanyAvatar do

   before(:each) do

     att = Paperclip::Attachment.new(:avatar, nil, {
         default_url: '/images/:style/missing.png',
         path: ":rails_root/public/system/:attachment/:id/:style/:filename",
         url: "/system/:attachment/:id/:style/:filename"
     });

     @attr = {
         avatar: att
     }

     @customer = FactoryGirl.create(:customer)
     @customer.company_avatar = CompanyAvatar.new(@attr)
   end

  it "responds to methods" do
    avatar = CompanyAvatar.new(@attr)
    avatar.should respond_to(:customer)
  end

   it "must be stored when customer_id is 0" do
     avatar = CompanyAvatar.new(@attr)
     avatar.customer_id = 0
     avatar.should be_valid
     expect {
       avatar.save!
     }.to change(CompanyAvatar, :count).by(1)
   end

  it "is valid when valid image is uploaded" do
    avatar = CompanyAvatar.new(@attr)
    avatar.customer = @customer
    avatar.avatar.should_not be_nil
    avatar.should be_valid

    expect {
      avatar.save!
    }.to change(CompanyAvatar,:count).by(1)
  end

  it "is valid when image is nil too" do
    avatar = CompanyAvatar.new(@attr.merge(:avatar => nil))
    avatar.customer = @customer
    avatar.should be_valid

    expect {
      avatar.save!
    }.to change(CompanyAvatar,:count).by(1)
  end

  it "destroys avatar when customer is deleted" do
    expect {
      @customer.destroy
    }.to change(CompanyAvatar,:count).by(-1)
  end

end
