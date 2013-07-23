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

end

World(UsersSupport)

###########################################################################
#################  common used Givens, Whens and Thens

Given(/^an existing user with name "([^"]*)", email "([^"]*)" and password "([^"]*)"$/) do |name, email, pwd|
  create_user({:name => name, :email => email, :password => pwd, :password_confirmation => pwd})
  sign_in
end


When(/^I click "(.*?)"$/) do |link|
  click_link link
end

###########################################################################