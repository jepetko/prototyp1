class LatlonInput < SimpleForm::Inputs::Base

  module LatlonRenderer
    def latlon_control(attr_name, *args, &block)
      self.template.render :partial => 'shared/map_control', :locals => { :options => args.nil? ? nil : args[0] }
    end
  end

  def input(*args, &block)
    if not @builder.respond_to?(:latlon_control)
      class << @builder
        include LatlonRenderer
      end
    end

    id = "#{@builder.object_name}_#{attribute_name.to_s}"
    name = "#{@builder.object_name}[#{attribute_name.to_s}]"
    options =  input_html_options.merge(:value => @builder.object.latlon.to_s,
                                        :id => id, :name => name)

    @builder.latlon_control(attribute_name, options).html_safe
  end

end