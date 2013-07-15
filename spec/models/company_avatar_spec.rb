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
     @attr = {
         avatar: att
     }

     ### prepare instances
     @customer = FactoryGirl.create(:customer)
     @customer.company_avatar = CompanyAvatar.new(@attr)
   end

  it "responds to methods" do
    avatar = CompanyAvatar.new(@attr)
    avatar.should respond_to(:customer)
  end

  it "is valid when valid image is uploaded" do
    avatar = CompanyAvatar.new(@attr)
    avatar.should be_valid

    expect {
      avatar.save!
    }.to change(CompanyAvatar,:count).by(1)
  end

  it "is valid when image is nil too" do
    avatar = CompanyAvatar.new(@attr.merge(:avatar => nil))
    avatar.should be_valid

    expect {
      avatar.save!
    }.to change(CompanyAvatar,:count).by(1)
  end

  it "destroys avatar when customer is deleted" do
    expect {
      @customer.destroy
      @customer.should be_frozen
    }.to change(CompanyAvatar,:count).by(-1)
  end

end
