
### GIVEN ###
Given(/^an existing user with these credentials:$/) do |table|
  # table is a Cucumber::Ast::Table
  users = table.hashes
  users.map do|user|
    symbolized_user = {}
    user.inject(symbolized_user){|memo,(k,v)| memo[k.to_sym] = v; memo}
    create_user symbolized_user
    sign_in
  end
end

#######

When(/^I click "(.*?)"$/) do |link|
  click_link link
end


When(/^fill the fields with these values and click "([^"]*)"$/) do |btn, table|
  values = table.hashes
  ##### ABC       | Funstreet   | 1010          | Vienna              | Austria
  values.map do |record|
    record.each do |k,v|
      field_name = "customer_#{k}"
      if k == 'country'
        select v, :from => field_name
      else
        fill_in field_name, :with => v
      end
    end
  end
  click_button btn if btn == 'Submit'
end


Then(/^I should see the message "(.*?)"$/) do |msg|
  expect(page).to have_content(msg)
end

Then(/^I should see the customer "(.*?)"$/) do |customer_name|
  expect(page).to have_content(customer_name)
end

Then(/^the number of customers should be "(.*?)"$/) do |count|
  expect(page).to have_selector('div.customer', :count => count)
end