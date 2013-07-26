module Utils

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

  def get_start_url
    port = Watir::Rails.port || 3000
    "http://localhost:#{port}/users/sign_in"
  end

  def create_browser(browser_name)
    raise 'browser_name must not be nil' if browser_name.nil?

    if browser_name.eql?'headless'
      #### Note: this will test headless but with an existing browser...
      #### see here: http://watirwebdriver.com/headless/
      $headless = @headless = Headless.new
      $browser = @browser = Watir::Browser.start get_start_url
    else
      #### this will test real browsers and headless (phantomjs) as well!
      $browser = @browser = Watir::Browser.new browser_name
    end
  end

  def make_screenshot(scenario)
    Dir::mkdir('screenshots') if not File.directory?('screenshots')
    screenshot = "./screenshots/FAILED_#{scenario.name.gsub(' ','_').gsub(/[^0-9A-Za-z_]/, '')}.png"
    @browser.screenshot.save(screenshot)
  end

end

World(Utils)

###########################################################################
#################  Common used Givens, Whens and Thens and Hooks

Given(/^an existing and logged-in user with name "([^"]*)", email "([^"]*)" and password "([^"]*)"$/) do |name, email, pwd|
  create_user({:name => name, :email => email, :password => pwd, :password_confirmation => pwd})
  sign_in
end

Given(/^an existing user with email "(.*?)" and password "(.*?)"$/) do |email, pwd|
  create_user({:name => 'Humpty Dumpty', :email => email, :password => pwd, :password_confirmation => pwd})
end

When(/^I open a browser instance "(.*?)"$/) do |browser|
  #authentication_token MUST be generated otherwise the server will deny the request
  Rails.application.config.action_controller.allow_forgery_protection = true
  Rails.application.config.serve_static_assets = false
  Rails.application.config.assets.compress = true
  Rails.application.config.assets.debug = true

  create_browser(browser)

end

When(/^I sign in in browser/) do
  if !@browser.nil?
    @browser.goto(get_start_url)
    @browser.text_field(:id, 'user_email').set(@user.email)
    @browser.text_field(:id, 'user_password').set(@user.password)
    @browser.button(:value, 'Sign in').click
  else
    raise "Not supported"
  end
end

When(/^I click "(.*?)"$/) do |link|
  click_link link
end

When(/^I click "(.*?)" in browser$/) do |link|
  @browser.link(:text, link).click
end


Before do
  DatabaseCleaner.start
end


After do |scenario|
  if scenario.failed?
    make_screenshot scenario
  end
  DatabaseCleaner.clean
end

After('@browser') do
  $headless.destroy if !$headless.nil?
  $browser.close if !$browser.nil?
end

###########################################################################