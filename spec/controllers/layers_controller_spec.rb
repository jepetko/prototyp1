require 'spec_helper'

describe Maps::LayersController do

  render_views

  before(:all) do
    @keys_should = [:id, :name, :clazz, :label, :type]
    @total_length = 4
  end

  describe 'routing' do
    it 'routes to #index' do
      { :get => 'layers' }.should route_to( :controller => 'maps/layers', :action => 'index')
    end
  end

  describe 'returned json' do

    before(:each) do
      request.env['HTTP_ACCEPT'] = 'application/json'
    end

    it 'returns array of layers' do
      get :index
      b = response.body
      b.should start_with('[')
      b.should end_with(']')
      arr = ActiveSupport::JSON.decode(b)
      arr.should be_a(Array)
      first = arr[0]
      first.should be_a(Hash)
      @keys_should.each do |key|
        first.should have_key(key.to_s)
      end
    end

    it 'returns filtered number of layers when passing type=base' do
      get :index, :type => 'base'
      arr = parse_response_body response
      arr.length.should be(3)
      arr.each do |layer|
        layer['type'].should eq('base')
      end
    end

    it 'returns empty array when passing type=none' do
      get :index, :type => 'none'
      arr = parse_response_body response
      arr.should be_empty
    end

    it 'returns all values when passing type=all' do
      get :index, :type => 'all'
      arr = parse_response_body response
      arr.length.should be(@total_length)
    end
  end

end