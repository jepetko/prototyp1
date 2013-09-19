require 'spec_helper'

describe LocationsController do

  render_views

  before(:all) do
    @inputs = [ {street: 'Siebenbrunnengasse', no: 44, city: 'Wien', zip: 1050, country: 'Austria'} ]
    @geocode_to_submit_strings = ['Siebenbrunnengasse 44, 1050 Wien, Austria']
  end

  describe 'routing' do
    it 'routes to #find' do
      { :get => 'locations/find', :country => 'Austria' }.should \
      route_to(:controller => 'locations', :action => 'find')
    end

  end

  describe 'when searching for an address' do

    before(:each) do
      request.env['HTTP_ACCEPT'] = 'application/json'
    end

    it 'submits the proper string to ruby Geocoder' do
      controller = LocationsController.new
      @inputs.each_with_index do |element,idx|
        str_should = @geocode_to_submit_strings[idx]
        str_is = nil
        controller.instance_eval do
          str_is = build_address_str element
        end
        str_is.should eq(str_should)
      end
    end

    it 'finds address and returns results' do
      @inputs.each do |element|
        get :find, element

        str = response.body
        str.should start_with('[')
        str.should end_with(']')
        obj = ActiveSupport::JSON.decode(str)
        obj.should be_a(Array)
      end
    end
  end

end