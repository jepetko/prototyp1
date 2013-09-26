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

    def get_relevant_params
      params.select {|key,val| (key != 'controller' && key != 'action' && key != 'format')}
    end

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


    ## this defines the filter block which will be evaluated in context of each array element

    def get_filter_features_block
      relevant_params = get_relevant_params
      return nil if relevant_params.size == 0

      keys = relevant_params.keys
      return Proc.new do |element|
        if keys.include?('type') && relevant_params['type'] == 'all'
          true
        elsif keys.include?('type') && relevant_params['type'] == 'none'
          false
        else
          str_to_eval = ''

          relevant_params.each do |key,val|
            str_to_eval << ' && ' if str_to_eval.length > 0
            next if val == ''
            /[^\d]+/.match(val) do |match|
              val = "'#{val}'"
            end
            str_to_eval << "element['#{key}'] == #{val}"
          end

          if str_to_eval == ''
            true
          else
            eval str_to_eval
          end
        end
      end
    end
  end
end