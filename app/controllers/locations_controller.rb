class LocationsController < ApplicationController

  def find
    str = build_address_str params

    g_result = Geocoder.search(str)
    result = []
    g_result.each do |element|
      data = element.data
      geom = data['geometry']
      loc = geom['location']
      result << { quality: get_quality(geom), lat: loc['lat'], lon: loc['lng'] }
    end

    respond_to do |format|
      format.json { render json: result }
    end
  end

  private

  def build_address_str(params)
    return '' if params.nil?
    str = ''
    [[:street],[:zip, :city]].each do |component|
      component.each do |sub_component|
        if params[sub_component]
          str << params[sub_component].to_s
        end
        str << ' '
      end
      str = "#{str.strip}, "
    end
    if params[:country]
      str << params[:country].to_s
    end
    str
  end

  def get_quality(loc)
    return 'high' if %w{ROOFTOP RANGE_INTERPOLATED}.include? loc['location_type']
    'low'
  end

end