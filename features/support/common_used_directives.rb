# encoding: utf-8

module Utils

  def self.extended(obj)
    obj.instance_exec {
      #authentication_token MUST be generated otherwise the server will deny the request
      Rails.application.config.action_controller.allow_forgery_protection = true
      Rails.application.config.serve_static_assets = false
      Rails.application.config.assets.compress = true
      Rails.application.config.assets.debug = true
      #Rails.application.config.i18n.locale = ENV['LANG'].to_sym || I18n.default_locale

      @browser = Watir::Browser.new ENV['BROWSER_TYPE'] || :phantomjs
      @browser.window.resize_to(2600, 600)
    }
  end

=begin
  def start_rails_server
    system 'bundle exec rake db:reset RAILS_ENV=test'
    system 'rm log/test.log'
    system 'rails s'
  end

  def terminate_rails_server
    system "kill $(ps auf | grep 'ruby script/rails' | grep -v grep | awk '{ print $2 }')"
  end
=end

  def make_screenshot(scenario)
    Dir::mkdir('screenshots') if not File.directory?('screenshots')
    screenshot = "./screenshots/FAILED_#{scenario.name.gsub(' ','_').gsub(/[^0-9A-Za-z_]/, '')}.png"
    @browser.screenshot.save(screenshot)
  end

end

World(Utils)

########################################################################################
#################  Common used Givens, Whens and Thens and Hooks     (english)

Given(/^an existing and logged-in user with name "([^"]*)", email "([^"]*)" and password "([^"]*)"$/) do |name, email, pwd|
  create_user({:name => name, :email => email, :password => pwd, :password_confirmation => pwd})
  sign_in
end

Given(/^an existing user with email "(.*?)" and password "(.*?)"$/) do |email, pwd|
  create_user({:name => 'Humpty Dumpty', :email => email, :password => pwd, :password_confirmation => pwd})
end

When(/^I sign in in browser/) do
  if @browser.nil?
    raise "Not supported"
  else
    @browser.goto('/users/sign_in')
    @browser.text_field(:id, 'user_email').set(@user.email)
    @browser.text_field(:id, 'user_password').set(@user.password)
    @browser.button(:value, 'Sign in').click
  end
end

When(/^I click "(.*?)"$/) do |link|
  click_link_or_button link
end

When(/^I click "(.*?)" in browser$/) do |link|
  l = @browser.link(:text, link)
  if !l.present?
    l = @browser.button(:value, link)
  end
  l.click
end

#########################################################################################
#################  Common used Givens, Whens and Thens and Hooks     (german)

Wenn(/^ich mich anmelde$/) do
  if @browser.nil?
    raise "Not supported"
  else
    @browser.goto('/users/sign_in')
    @browser.text_field(:id, 'user_email').set(@user.email)
    @browser.text_field(:id, 'user_password').set(@user.password)
    @browser.button(:value, 'Sign in').click
  end
end

Wenn(/^ich auf "(.*?)" klicke$/) do |link|
  l = @browser.link(:text, link)
  if !l.present?
    l = @browser.button(:value, link)
  end
  l.click
end

Angenommen(/^es gibt einen User mit der Email "(.*?)" und Passwort "(.*?)"$/) do |email, pwd|
  create_user({:email => email, :name => email, :password => pwd, :password_confirmation => pwd})
  sign_in
end

######################################################################################
############## Hooks

Before do
  DatabaseCleaner.start
end

After do |scenario|
  if scenario.failed?
    make_screenshot scenario
  end
  DatabaseCleaner.clean
end

###########################################################################