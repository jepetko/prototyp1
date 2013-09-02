When(/^customer with "([^"]*)", "([^"]*)", "([^"]*)", "([^"]*)", "([^"]*)" and "([^"]*)"$/) do |name, street, zip, city, country, latlon|
  customer = Customer.create(name: name, street: street, zip: zip, city: city, country: country, latlon: latlon)
  customer.save!
end

When(/^I try to edit "([^"]*)"$/) do |name|
  customer = Customer.where( name: name)
  visit edit_customer_path(id: customer.first.id)
end

When(/^I remove the values and try to save$/) do
  fill_in :customer_name, with: ''
  fill_in :customer_street, with: ''
  fill_in :customer_zip, with: ''
  fill_in :customer_city, with: ''
  fill_in :customer_latlon, with: ''
  click_button 'Update Customer'
end