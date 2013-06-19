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