class CompanyAvatarsController < ApplicationController

  include TemporaryUploadSupport

  before_filter :authenticate_user!

  # POST /company_avatars
  # POST /company_avatars.json
  def create
    @company_avatar = CompanyAvatar.new(params[:company_avatar])

    if params[:customer_id]
      @company_avatar.customer_id = params[:customer_id]
    end

    respond_to do |format|
      if @company_avatar.save

        #save in session
        remember_temp_upload(@company_avatar.id)

        format.html { redirect_to @company_avatar, notice: I18n.t('views.company_avatar.flash_messages.created_successfully') }
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

    remove_temp_upload

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
      format.html # show.html.erb
      format.json { render json: @company_avatar.to_jq_upload }
    end
  end

end
