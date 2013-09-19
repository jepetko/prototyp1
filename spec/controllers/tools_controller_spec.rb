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

  it 'should return bunch of tools' do
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