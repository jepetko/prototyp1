#http://stackoverflow.com/questions/12370056/omniauth-strategies-facebook-noauthorizationcodeerror-must-pass-either-a-code
OmniAuth.config.on_failure = Proc.new do |env|
  OmniAuth::FailureEndpoint.new(env).redirect_to_failure
end