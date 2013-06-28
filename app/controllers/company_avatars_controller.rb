class CompanyAvatarsController < ApplicationController

  # POST /company_avatars
  # POST /company_avatars.json
  def create
    @company_avatar = CompanyAvatar.new(params[:company_avatar])

    respond_to do |format|
      if @company_avatar.save
        format.html { redirect_to @company_avatar, notice: 'Company avatar was successfully created.' }
        format.json { render json: @company_avatar.to_jq_upload, status: :created, location: @company_avatar }
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
end
