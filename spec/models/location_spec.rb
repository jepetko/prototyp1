require 'spec_helper'

describe Location do

  before(:each) do
    @location = Location.new
  end

  it 'responds to methods' do
    @location.should respond_to(:street)
    @location.should respond_to(:zip)
    @location.should respond_to(:city)
    @location.should respond_to(:country)
  end

  it 'should be invalid when passing non-numeric zip' do
    @location.zip = 'A-1020'
    @location.should_not be_valid
    @location.errors.messages.should have_key(:zip)
    @location.errors.messages[:zip].should include(I18n.t('errors.messages.not_a_number'))
  end

  it 'should not be able to store any records' do
    @location.should_not respond_to(:save)
  end

end
