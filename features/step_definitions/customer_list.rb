Given(/^following records in the database:$/) do |table|

  create_customers table

end

Then(/^I must see "(.*?)" customers$/) do |count|
  expect(page).to have_xpath('//div[@class="thumbnail customer"]', :count => count)
end
