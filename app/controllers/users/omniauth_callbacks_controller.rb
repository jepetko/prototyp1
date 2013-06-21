class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    auth "Facebook"
  end

  def linkedin
    auth "LinkedIn"
  end

  def xing
    auth "Xing"
  end


  #########################################

  def failure
    flash[:error] = 'Error while authentication.'
    redirect_to '/'
  end

  protected
  def auth(kind)
    # You need to implement the method below in your model (e.g. app/models/user.rb
    kind = kind.downcase
    @user = User.send( "find_for_#{kind}_oauth".to_s, request.env["omniauth.auth"], current_user)

    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => kind) if is_navigational_format?
    else
      session["devise.#{kind}_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
end