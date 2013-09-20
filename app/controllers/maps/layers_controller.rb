require_relative 'maps'

class Maps::LayersController < ApplicationController

  include Maps::Actions

  def get_index_tpl_path
    "#{Rails.root}/app/assets/json/ol_layers.json"
  end

end