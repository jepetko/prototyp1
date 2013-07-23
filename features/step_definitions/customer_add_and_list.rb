
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

When(/^I click "(.*?)"$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

When(/^fill the fields with these values$/) do |table|
  # table is a Cucumber::Ast::Table
  pending # express the regexp above with the code you wish you had
end

Then(/^I should see the message "(.*?)"$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then(/^I should see the customer "(.*?)"$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then(/^the number of customers should be "(.*?)"$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

When(/^I call the URL "(.*?)"$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then(/^I will be redirected to the Log\-In page$/) do
  pending # express the regexp above with the code you wish you had
end
