module UsersSupport

  def create_visitor(visitor = nil)
    if visitor.nil?
      @visitor = { :name => "Testy McUserton", :email => "example@example.com",
                   :password => "changeme", :password_confirmation => "changeme" }
    else
      [:name, :email, :password, :password_confirmation].map do |el|
        raise "attr not sufficient because #{el} is missing" if !visitor.keys.include?(el)
      end
      @visitor = visitor
    end
  end

  def find_user
    @user ||= User.first conditions: {:email => @visitor[:email]}
  end

  def create_unconfirmed_user
    create_visitor
    delete_user
    sign_up
    visit '/users/sign_out'
  end

  def create_user(visitor = nil)
    create_visitor visitor
    delete_user
    @user = FactoryGirl.create(:user, @visitor)    ### bug-fix
  end

  def delete_user
    @user ||= User.first conditions: {:email => @visitor[:email]}
    @user.destroy unless @user.nil?
  end

  def sign_up
    delete_user
    visit '/users/sign_up'
    fill_in "Name", :with => @visitor[:name]
    fill_in "Email", :with => @visitor[:email]
    fill_in "user_password", :with => @visitor[:password]
    fill_in "user_password_confirmation", :with => @visitor[:password_confirmation]
    click_button "Sign up"
    find_user
  end

  def sign_in
    visit '/users/sign_in'
    fill_in "Email", :with => @visitor[:email]
    fill_in "Password", :with => @visitor[:password]
    click_button "Sign in"
  end

  def create_customers(table)
    table.hashes.each do |rec|
      FactoryGirl.create(:customer, :name => rec[:name])
    end
  end

  def start_rails_server
    system 'bundle exec rake db:reset RAILS_ENV=test'
    system 'rm log/test.log'
    system 'rails s'
  end

  def terminate_rails_server
    system "kill $(ps auf | grep 'ruby script/rails' | grep -v grep | awk '{ print $2 }')"
  end

end

World(UsersSupport)

###########################################################################
#################  common used Givens, Whens and Thens and Hooks

Before('@browser') do
  #start_rails_server
end

After('@browser') do
  #terminate_rails_server
end

Given(/^an existing and logged-in user with name "([^"]*)", email "([^"]*)" and password "([^"]*)"$/) do |name, email, pwd|
  create_user({:name => name, :email => email, :password => pwd, :password_confirmation => pwd})
  sign_in
end

Given(/^an existing user with email "(.*?)" and password "(.*?)"$/) do |email, pwd|
  create_user({:name => 'Humpty Dumpty', :email => email, :password => pwd, :password_confirmation => pwd})
end

When(/^I open a browser instance "(.*?)"$/) do |browser|
  @browser = Watir::Browser.new browser
end

When(/^I sign in/) do
  if !@browser.nil?
    @browser.goto("http://localhost:#{Watir::Rails.port}/users/sign_in")
    @browser.text_field(:id, 'user_email').set(@user.email)
    @browser.text_field(:id, 'user_password').set(@user.password)
    @browser.button(:value, 'Sign in').click
  else
    raise "Not supported"
  end
end

When(/^I click "(.*?)"$/) do |link|
  if !@browser.nil?
    @browser.link(:text,'Customer').click
    @browser.link(:text, 'New customer').click
  else
    click_link link
  end
end

###########################################################################