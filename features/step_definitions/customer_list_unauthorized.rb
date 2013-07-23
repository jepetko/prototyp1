When(/^I call the URL "(.*?)"$/) do |url|
  visit url
end

Then(/^I will be redirected to the Log\-In page$/) do
  response.should redirect_to('/users/sign_in')
end
