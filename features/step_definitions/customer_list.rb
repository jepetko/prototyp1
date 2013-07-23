Given(/^following records in the database:$/) do |table|

  table.hashes.each do |rec|
    FactoryGirl.create(:customer, :name => rec[:name])
  end

end

Then(/^I must see "(.*?)" customers$/) do |count|
  expect(page).to have_xpath('//div[@class="thumbnail customer"]', :count => count)
end
