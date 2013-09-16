require 'spec_helper'

describe ApplicationController do

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

    @localizations = [ I18n.t('views.map.layer_bing_1'), I18n.t('views.map.layer_bing_2'),
                       I18n.t('views.map.layer_bing_3'), I18n.t('views.map.customers') ]

    @controller = ApplicationController.new
  end

  it 'can deserialize the template and find matches' do
    filled_tpl = @controller.localize_json_template @tpl

    result = ActiveSupport::JSON.decode(filled_tpl)
    loops = 0
    result.each_with_index do |element,idx|
      element['label'].should eq(@localizations[idx])
      loops += 1
    end
    loops.should be(4)
  end

end