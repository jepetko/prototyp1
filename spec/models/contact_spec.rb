require 'spec_helper'

describe Contact do

  before(:each) do
    @attr = {
        name: 'edward with the scissorhands',
        notice: 'You are my hero.',
        phone: '00431123456'
    }
    @customer = FactoryGirl.create(:customer)
  end

  it 'responds to the methods' do
    contact = Contact.new(@attr)
    contact.should respond_to(:customer)
  end

  it 'must not store record when customer is missing' do
    contact = Contact.new(@attr)
    contact.should_not be_valid

    contact.errors.messages.each do |key,val|
      key.should eq(:customer_id)
      val.should include("can't be blank")
    end

  end

  it 'stores valid record' do
    contact = Contact.new(@attr)
    contact.customer = @customer
    contact.should be_valid
    expect {
      contact.save!
    }.to change(Contact,:count).by(1)
  end

  it "doesn't store record when passing invalid values" do

    [ @attr.merge(:name => nil),
      @attr.merge(:phone => 'abc') ].each do |attr|

      contact = Contact.new(attr)
      contact.customer = @customer
      contact.should_not be_valid
      expect {
        contact.save!
      }.to raise_error ActiveRecord::RecordInvalid

    end
  end

  it "destroys contact when customer is destroyed" do
    contact = Contact.new(@attr)
    contact.customer = @customer
    contact.save!
    expect {
      @customer.destroy
    }.to change(Contact,:count).by(-1)
  end
end