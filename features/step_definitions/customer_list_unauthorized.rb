When(/^I call the URL "(.*?)"$/) do |url|
  visit url
end

Then(/^I will be redirected to the Log\-In page$/) do
  current_path.should eq('/users/sign_in')
end
