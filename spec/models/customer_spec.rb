require 'spec_helper'

describe Customer do

  before(:each) do
    @attr = {
        city: 'Vienna',
        country: 'AUT',
        name: 'Company Limited',
        street: 'Funny Street 1',
        zip: '1010',
        latlon: 'POINT(16.344 48.185)'
    }

    @polygon = 'POLYGON((16.343390733776932 48.18425220210939,16.343390733776932 48.190861439574796,16.3574240513432 48.190861439574796,16.3574240513432 48.18425220210939,16.343390733776932 48.18425220210939))'
  end

  it 'responds to methods' do
    customer = Customer.create!(@attr)

    customer.should respond_to(:company_avatar)
    customer.should respond_to(:contacts)
    Customer.should respond_to(:find_by_keyword)
    Customer.should respond_to(:find_by_geom)
  end

  it 'stores valid record' do
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
    }.to raise_error ActiveRecord::RecordInvalid
  end

  it "doesn't store invalid record (duplicate name)" do
    Customer.create!(@attr)
    customer = Customer.new(@attr)
    customer.should_not be_valid

    expect {
      customer.save!
    }.to raise_error ActiveRecord::RecordInvalid
  end

  it 'returns customers intersecting the passed polygon' do
    customer = Customer.create!(@attr)
    customers = Customer.find_by_geom(@polygon)
    customers.should include(customer)
  end

end
