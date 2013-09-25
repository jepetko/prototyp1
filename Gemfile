source 'https://rubygems.org'
ruby '1.9.3'

gem 'rails', '3.2.8'
gem 'pg'
#### gem 'activerecord-postgis-adapter'

#i18n
gem 'rails-i18n', '~> 3.0.0.pre' # For 3.x

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end
gem 'jquery-rails'
gem "thin", ">= 1.5.0"

group :development, :test do
  gem "rspec"
  gem "rspec-core"
  gem "rspec-rails", ">= 2.12.2"
  gem "webrat"
  gem "cucumber", ">= 1.3.2"
  gem "cucumber-rails", ">= 1.3.1", :require => false
  gem "faker", :require => false
  #gem "watir"
  gem "watir-rails"
  gem "headless"
end


gem "database_cleaner", ">= 1.0.0.RC1", :group => :test
gem "email_spec", ">= 1.4.0", :group => :test
gem "launchy", ">= 2.2.0", :group => :test
gem "capybara", ">= 2.0.3", :group => :test
gem "factory_girl_rails", ">= 4.2.0", :group => [:development, :test]
gem "bootstrap-sass", ">= 2.3.0.0"
gem "devise", ">= 2.2.3"
gem "cancan", ">= 1.6.9"
gem "rolify", ">= 3.2.0"
gem "simple_form", ">= 2.1.0"
gem "quiet_assets", ">= 1.0.2", :group => :development
gem "figaro", ">= 0.6.3"
gem "better_errors", ">= 0.7.2", :group => :development
gem "binding_of_caller", ">= 0.7.1", :group => :development, :platforms => [:mri_19, :rbx]
gem "libv8", ">= 3.11.8"
gem "therubyracer", ">= 0.11.3", :group => :assets, :platform => :ruby, :require => "v8"
gem "hub", ">= 1.10.2", :require => nil, :group => [:development]

#facebook integration
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-linkedin'
gem 'omniauth-xing'

#could not find multipart-post-1.2.0 in any of the sources: multipart-post-1.2.0
gem "multipart-post", ">= 1.2.0"

#debugging
group :development, :test do
  gem "ruby-debug-base19x", "0.11.30.pre12"
  gem "ruby-debug-ide", "0.4.17.beta17"
  gem "spork"
end

#for simple_form
gem "country_select"

#picture upload
gem "paperclip", "~> 3.0"

# To use Jbuilder templates for JSON
gem 'jbuilder'
gem "jquery-fileupload-rails", "0.4.1"

# for paginate
gem "will_paginate-bootstrap"
gem "rack-reverse-proxy", :require => "rack/reverse_proxy"
gem 'htmlentities'

# for spatial dimension
gem 'rgeo'
gem 'activerecord-postgis-adapter'
gem 'rgeo-geojson'
gem 'geocoder'
gem 'squeel'