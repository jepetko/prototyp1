module CustomersHelper

  def get_avatar_img(customer, type)
    unless customer.nil?
      if not customer.company_avatar.nil?
        return image_tag customer.company_avatar.avatar.url(type)
      end
    end
    ''
  end

  def to_geojson(customers)
    str = ''
    customers.each do |customer|
      if str != ''
        str << ','
      end
      str << '{"type" : "Feature",'
      str << "\"id\": #{customer.id},"
      str << "\"geometry\": #{RGeo::GeoJSON.encode(customer.latlon).to_json},"
      str << '"geometry_name" : "SHAPE",'
      str << "\"properties\" : #{customer.to_json(:except => [:id, :latlon])}"
      str << '}'
    end
    '{"type":"FeatureCollection","features":[' + str + ']}'
  end

end
