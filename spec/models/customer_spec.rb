require 'spec_helper'

describe Customer do

  before(:each) do
    @attr = {
        city: 'Vienna',
        country: 'AUT',
        name: 'Company Limited',
        street: 'Funny Street 1',
        zip: '1010'
    }
  end

  it "responds to methods" do
    customer = Customer.create!(@attr)

    customer.should respond_to(:company_avatar)
    customer.should respond_to(:contacts)
  end

  it "stores valid record" do
    expect {
      customer = Customer.new(@attr)
      customer.should be_valid
      customer.save
    }.to change(Customer,:count).by(1)
  end

  it "doesn't store invalid record (missing city)" do
    customer = Customer.new(@attr.merge(:city => nil))
    customer.should_not be_valid

    expect {
      customer.save!
    }.should raise_error ActiveRecord::RecordInvalid
  end

  it "doesn't store invalid record (duplicate name)" do
    orig_customer = Customer.create!(@attr)
    customer = Customer.new(@attr)
    customer.should_not be_valid

    expect {
      customer.save!
    }.should raise_error ActiveRecord::RecordInvalid
  end

end
