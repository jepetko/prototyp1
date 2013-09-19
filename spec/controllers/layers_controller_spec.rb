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

  it 'should return bunch of layers' do
    request.env['HTTP_ACCEPT'] = 'application/json'
    get :index
    b = response.body
    b.should start_with('[')
    b.should end_with(']')
    obj = ActiveSupport::JSON.decode(b)
    obj.should be_a(Array)
    first = obj[0]
    first.should be_a(Hash)
    @keys_should.each do |key|
      first.should have_key(key.to_s)
    end
  end

end