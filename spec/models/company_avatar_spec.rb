require 'spec_helper'
require 'paperclip'

describe CompanyAvatar do

   before(:each) do

     #### prepare attachment
     att = Paperclip::Attachment.new(:avatar, @customer, {
         default_url: '/images/:style/missing.png',
         path: ":rails_root/public/system/:attachment/:id/:style/:filename",
         url: "/system/:attachment/:id/:style/:filename"
     });

     ### prepare instances
     @customer = FactoryGirl.create(:customer)
     @customer.company_avatar = CompanyAvatar.new(@attr)

     @attr = {
         avatar: att
     }
   end

  it "responds to methods" do
    avatar = CompanyAvatar.new(@attr)
    avatar.should respond_to(:customer)
  end

   it "must not be stored when customer is missing" do
     avatar = CompanyAvatar.new(@attr)
     avatar.should_not be_valid
     avatar.errors.messages.each do |key,val|
       key.should eq(:customer_id)
       val.should include('must be greater than 0')
     end
   end

  it "is valid when valid image is uploaded" do
    avatar = CompanyAvatar.new(@attr)
    avatar.customer = @customer
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
