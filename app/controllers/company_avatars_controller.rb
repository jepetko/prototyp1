class CompanyAvatarsController < ApplicationController

  include TemporaryUploadSupport

  before_filter :authenticate_user!

  # avatar upload features
  after_filter :remember_avatar, :only => [:create]
  after_filter :consume_avatar, :only => [:destroy]

  # POST /company_avatars
  # POST /company_avatars.json
  def create
    attrs = params[:company_avatar].merge(:customer_id => params[:customer_id] || 0)
    @company_avatar = CompanyAvatar.new(attrs)

    respond_to do |format|
      if @company_avatar.save
        format.json { render json: @company_avatar.to_jq_upload, status: :created, location: [@company_avatar.customer, @company_avatar] }
      else
        format.html { render action: "new" }
        format.json { render json: @company_avatar.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /company_avatars/1
  # DELETE /company_avatars/1.json
  def destroy
    @company_avatar = CompanyAvatar.find(params[:id])
    @company_avatar.destroy

    respond_to do |format|
      format.html { redirect_to company_avatars_url }
      format.json { head :no_content }
    end
  end

  # GET /company_avatars/1
  # GET /company_avatars/1.json
  def show
    @company_avatar = CompanyAvatar.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @company_avatar.to_jq_upload }
    end
  end

  private

  def remember_avatar
    remember_temp_upload(@company_avatar.id)
  end

  def consume_avatar
    remove_temp_upload
  end

end
