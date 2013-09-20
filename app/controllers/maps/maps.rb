module Maps
end

module Maps::Actions

  def self.included(base)
    ## include even more modules and add before filters automatically
    base.class_eval do
      include Maps::Features
      before_filter :filter_template, :only => [:index]
    end
  end

  def index
    raise NoMethodError, "method :get_index_tpl_path should be implemented by #{self.class.name}" if !self.respond_to?(:get_index_tpl_path)
    res = localize_json_template @tpl
    respond_to do |format|
      format.json { render json: res }
    end
  end

  module Maps::Features

    def filter_template
      @tpl = File.read self.get_index_tpl_path
      apply_filters
    end

    def apply_filters
      arr = ActiveSupport::JSON.decode(@tpl)
      filter_block = get_filter_features_block
      filtered_arr = arr.select &filter_block
      @tpl = ActiveSupport::JSON.encode(filtered_arr)
    end

    ## this method is overridden by layers_controller and tools_controller to specify the particular
    ## filtering method
    def get_filter_features_block
      raise Error, "method get_filter_features_block not implemented by a subclass. Please check the implementation of #{self.class}"
    end
  end
end