class LatlonInput < SimpleForm::Inputs::Base

  module LatlonRenderer
    def latlon_control(attr_name, *args, &block)
      #'<p style="border: 1px solid red;"></p>'
      self.template.render :partial => 'shared/map_control'
    end
  end

  class SimpleForm::FormBuilder
    def method_missing(name, *args, &block)
      if name.to_sym != :latlon_control
        super
      else
        class << self
          include LatlonRenderer
        end
        self.latlon_control(name,*args,&block)
      end
    end
  end

  def input
    @builder.latlon_control(attribute_name, input_html_options.merge(:value => @builder.object.latlon.to_s)).html_safe
  end

end