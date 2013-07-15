module ApplicationHelper

  def display_base_errors resource
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