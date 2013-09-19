require_relative 'maps'

class Maps::ToolsController < ApplicationController

  include Maps::Actions

  def get_index_tpl_path
    "#{Rails.root}/app/assets/json/ol_tools.json"
  end

end