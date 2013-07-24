Given(/^following customers:$/) do |table|
  create_customers table
end

When(/^I click at "([^"]*)" button of the customer with name (.*)$/) do |btn, name|
  find("//div[@class=\"thumbnail customer\"]/h3[text()=\"#{name}\"]").find(:xpath, './..').click_link('Show')
end

Then(/^I should see a single customer with name (.*)$/) do |name|
  expect(page).to have_content(name)
end