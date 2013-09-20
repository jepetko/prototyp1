class LatlonInput < SimpleForm::Inputs::Base

  module LatlonRenderer

    ## this will generate a latlon control from a partial
    def latlon_control(attr_name, *args, &block)
      self.template.render :partial => 'shared/map_control', :locals => { :options => args.nil? ? nil : args[0] }
    end
  end

  ## implementing the method input
  def input(*args, &block)

    ## for testing
    if Rails.env.test?
      return @builder.text_field attribute_name, *args, &block
    end

    ## dynamic object extension if builder doesn't respond to it
    if not @builder.respond_to?(:latlon_control)
      class << @builder
        include LatlonRenderer
      end
    end

    id = "#{@builder.object_name}_#{attribute_name.to_s}"
    name = "#{@builder.object_name}[#{attribute_name.to_s}]"
    options =  input_html_options.merge(:value => @builder.object.latlon.to_s,
                                        :id => id, :name => name,
                                        :tools_filter => @options[:tools_filter],
                                        :layers_filter => @options[:layers_filter])
    @builder.latlon_control(attribute_name, options).html_safe
  end

end