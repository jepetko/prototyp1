# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)

require 'rack/reverse_proxy'
require 'htmlentities'

class Rack::ReverseProxyMatcher

  alias_method :get_uri_without_decode, :get_uri

  def get_uri(path,env)
    url = get_uri_without_decode(path,env)
    if url.path.start_with?('http%')
      url = URI.decode url.path
      url = URI(url)
    end
    url
  end
end


use Rack::ReverseProxy do
  # Set :preserve_host to true globally (default is true already)
  reverse_proxy_options :preserve_host => true

  # Forward the path /test* to http://example.com/test*
  #reverse_proxy '/proxy', 'http://www.leanetic.com'

  # Forward the path /foo/* to http://example.com/bar/*
  reverse_proxy /^\/proxy\?url=(.*)$/, "$1"
end

run Prototyp1::Application
