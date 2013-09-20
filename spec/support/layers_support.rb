module LayersSupport
  include CommonSupport
end

RSpec.configure do |config|
  config.include LayersSupport, :type => :controller
end
