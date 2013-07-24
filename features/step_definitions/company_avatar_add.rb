

When(/^choose a file "(.*?)"$/) do |arg1|
  @browser.file_field(:id, 'company_avatar_avatar').set("#{Rails.root}/features/support/logo_1.png")
  #pending
end

Then(/^the chosen file "(.*?)" will appear in the page$/) do |arg1|
  expect(@browser.td(:class,'name').span.text).to eq('logo_1.png')
end

Then(/^I am able to click the button "(.*?)"$/) do |arg1|
  @browser.i(:class, 'icon-upload').click
  Watir::Wait.until {
    @browser.tr(:class, 'template-download').link(:xpath, 'td/a[contains(@href,"logo")]').present?
  }

#  b = @browser
#  Watir::Wait.until { b.tr(:class, 'template-download').td(:xpath,'td[3]').text.include? 'Thank you' }
end

Then(/^the logo will appear in the page$/) do
  pending
end

Then(/^I can see the size of the image "(.*?)"$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end