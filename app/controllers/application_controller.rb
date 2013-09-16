class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

  def localize_json_template(template)
    obj = ActiveSupport::JSON.decode(template)
    regexp = /^\{(.*)\}$/
    obj.each do |element|
      continue if element['label'].nil?
      regexp.match(element['label']) { |result|
        if result.length > 1
          element['label'] = t(result[1])
        end
      }
    end
    ActiveSupport::JSON.encode(obj)
  end
end
