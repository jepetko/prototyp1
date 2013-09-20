require_relative 'maps'

class Maps::LayersController < ApplicationController

  include Maps::Actions

  def get_index_tpl_path
    "#{Rails.root}/app/assets/json/ol_layers.json"
  end

  def get_filter_features_block
    return nil if !params.keys.include?('type')   #currently filters can handle types only
    type = params[:type]
    return Proc.new do |layer|
      if type == 'all'
        true
      elsif type == 'none'
        false
      else
        layer['type'] == type
      end
    end
  end

end