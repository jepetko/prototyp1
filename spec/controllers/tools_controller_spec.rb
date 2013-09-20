require 'spec_helper'

describe Maps::ToolsController do

  render_views

  before(:all) do
    @keys_should = [:id, :label, :icon]
  end

  describe 'routing' do
    it 'routes to #index' do
      { :get => 'tools' }.should route_to( :controller => 'maps/tools', :action => 'index')
    end
  end

  describe 'when filtering json configuration' do

    before(:each) do
      request.env['HTTP_ACCEPT'] = 'application/json'
    end

    it 'returns bunch of tools' do
      get :index
      b = response.body
      b.should start_with('[')
      b.should end_with(']')
      obj = ActiveSupport::JSON.decode(b)
      obj.should be_a(Array)
      obj.length.should be(3)
      first = obj[0]
      first.should be_a(Hash)
      @keys_should.each do |key|
        first.should have_key(key.to_s)
      end
    end

    it 'returns filtered tools with id=zoom' do
      get :index, :id => 'zoom'
      obj = parse_response_body response
      obj.should be_a(Array)
      obj.length.should be(1)
      obj[0]['id'].should eq('zoom')
    end

    it 'returns filtered tools with group=0' do
      get :index, :group => 0
      obj = parse_response_body response
      obj.should be_a(Array)
      obj.length.should be(1)
      obj[0]['group'].should eq(0)
    end
  end

end