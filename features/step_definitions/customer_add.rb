### GIVEN ###

### see users_support.rb

#######


When(/^fill the fields with (.*), (.*), (.*), (.*) and (.*) and click subsequently "([^"]*)"$/) do |name, street, zip, city, country, btn|

  fill_in :customer_name, :with => name
  fill_in :customer_street, :with => street
  fill_in :customer_zip, :with => zip
  fill_in :customer_city, :with => city

  select country, :from => :customer_country

  click_button btn if btn == 'Create Customer'
end

############ common used Then's ######################################

Then(/^I should see the message "(.*?)"$/) do |msg|
  expect(page).to have_content(msg)
end
