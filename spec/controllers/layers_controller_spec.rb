require 'spec_helper'

describe Maps::LayersController do

  render_views

  before(:all) do
    @keys_should = [:id, :name, :clazz, :label, :type]
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

    it 'returns filtered number of layers when passing lvl=base' do
      get :index, :type => 'base'
      b = response.body
      arr = ActiveSupport::JSON.decode(b)
      arr.each do |layer|
        layer['type'].should eq('base')
      end
    end

  end

end