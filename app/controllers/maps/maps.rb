module Maps
end

module Maps::Actions
  def index
    raise NoMethodError, "method :get_index_tpl_uri should be implemented by #{self.class.name}" if !self.respond_to?(:get_index_tpl_path)
    @tpl = File.read self.get_index_tpl_path
    res = localize_json_template @tpl
    respond_to do |format|
      format.json { render json: res }
    end
  end
end