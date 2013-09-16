module ApplicationHelper

  def map_capable_actions
    [:map, :new, :edit, :create]
  end

  def display_base_errors(resource)
    return '' if (resource.errors.empty?) or (resource.errors[:base].empty?)
    messages = resource.errors[:base].map { |msg| content_tag(:p, msg) }.join
    html = <<-HTML
    <div class="alert alert-error alert-block">
      <button type="button" class="close" data-dismiss="alert">&#215;</button>
      #{messages}
    </div>
    HTML
    html.html_safe
  end

  def controller_specific_root_class(params)
    ['root', "#{params[:controller].html_safe}", "#{params[:action].html_safe}"].join('-')
  end

  def controller_specific_includes(params)
    ##TODO: should that be configurable somewhere??
    if params[:controller] == 'customers' && map_capable_actions.include?(params[:action].to_sym)
      javascript_include_tag 'spatial'
    end
  end

  #deprecated
  def get_current_route
    url_for(:only_path => false, :overwrite_params=>nil).gsub(/http[s]?\:\/\/[\w]+[\:]?[\d]+/,'')
  end

  #deprecated
  def is_in_edit_mode(controller)
    edit_url = url_for :controller => controller.class.name.downcase.pluralize, :action => 'edit', :id => controller.id
    true if (edit_url =~ /#{get_current_route}/) == 0
    false
  end
end