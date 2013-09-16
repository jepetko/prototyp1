class LayersController < ApplicationController

  def index
    @tpl = File.read "#{Rails.root}/app/assets/json/ol_layers.json"
    res = localize_json_template @tpl
    respond_to do |format|
      format.json { render json: res }
    end

  end

end