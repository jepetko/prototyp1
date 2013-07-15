require 'spec_helper'
require 'paperclip'

describe CompanyAvatar do

   before(:each) do
     @customer = FactoryGirl.create(:customer)

     att = Paperclip::Attachment.new(:avatar, @customer, {
         default_url: '/images/:style/missing.png',
         path: ":rails_root/public/system/:attachment/:id/:style/:filename",
         url: "/system/:attachment/:id/:style/:filename"
     });
     @attr = {
        avatar: att
     }

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


end
