class LatlonInput < SimpleForm::Inputs::Base
  def input
    @builder.text_field(attribute_name, input_html_options.merge(:value => @builder.object.latlon.to_s)).html_safe
  end
end