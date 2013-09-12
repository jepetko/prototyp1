require 'spec_helper'

describe ApplicationHelper do

  before(:all) do
    @tpl = '['\
    '{   "id" : "layer_1",'\
        '"name" : "Bing Maps Road",'\
        '"key": "xyz",'\
        '"clazz" : "Bing",'\
        '"clazz-type": "Road",'\
        '"label" : "{views.map.layer_bing_1}",'\
        '"type" : "base"},'\
    '{   "id" : "layer_2",'\
        '"name" : "Bing Maps Aerial Labels",'\
        '"key": "xyz",'\
        '"clazz" : "Bing",'\
        '"clazz_type": "AerialWithLabels",'\
        '"label" : "{views.map.layer_bing_2}",'\
        '"type" : "base"},'\
    '{   "id" : "layer_3",'\
        '"name" : "Bing Maps Aerial",'\
        '"key": "xyz",'\
        '"clazz" : "Bing",'\
        '"clazz_type": "Aerial",'\
        '"label" : "{views.map.layer_bing_3}",'\
        '"type" : "base"},'\
    '{   "id" : "layer_4",'\
        '"name" : "Customers",'\
        '"clazz" : "Vector",'\
        '"label" : "{views.map.customers}",'\
        '"type" : "wfs",'\
        '"url" : "/customers.geojson",'\
        '"use_proxy" : false }'\
    ']'

    @last_hash = { id: 'layer_4', name: 'Customers', clazz: 'Vector',
                   label: '{views.map.customers}', type: 'wfs', url: '/customers.geojson', use_proxy: false}
  end

  it 'can deserialize the template to an object' do
    obj = ActiveSupport::JSON.decode(@tpl)
    obj.count.should be(4)

    @last_hash.each do |key,val|
      key_str = key.to_s
      obj.last.should have_key(key_str)
      obj.last[key_str].should eq(val)
    end
  end

end