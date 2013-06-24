module OmniAuthFacebookIntegration
  OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
                                                                    :provider => 'facebook',
                                                                    :uid => '123545',
                                                                    :extra => {
                                                                        :raw_info => {
                                                                            :name => 'stupid'
                                                                        }
                                                                    },
                                                                    :info => {
                                                                        :email => 'usr@country.xx'
                                                                    }
                                                                })
end

module LoginLogoutHelpers

  def test_log_in(user)
    raise 'You (' + user.email + ') are not authorized!' if not user.valid_password?(user.password)
    sign_in(:user, user)
  end

  def test_log_out(user)
    sign_out(user)
  end

end

RSpec.configure do |config|
  config.include LoginLogoutHelpers, :type => :controller
end
