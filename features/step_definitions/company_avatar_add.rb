
When(/^choose a file "(.*?)"$/) do |arg1|
  #firefox issue: otherwise following error is raised:
  #Element is not currently visible and so may not be interacted with (Selenium::WebDriver::Error::ElementNotVisibleError)
  #removing class name seems not to be possible in this configuration
  #browser.span(:class, 'fileinput-button').tap {|x| puts x.methods }.class_name
  @browser.file_field(:id, 'company_avatar_avatar').set("#{Rails.root}/features/support/logo_1.png")
end

Then(/^the chosen file "(.*?)" will appear in the page$/) do |arg1|
  expect(@browser.td(:class,'name').span.text).to eq('logo_1.png')
end

Then(/^I am able to click the button "(.*?)"$/) do |arg1|
  @browser.i(:class, 'icon-upload').click
end

Then(/^the logo will appear in the page$/) do
  Watir::Wait.until {
    @browser.tr(:class, 'template-download').link(:xpath, 'td/a[contains(@href,"logo")]').present?
  }
end

Then(/^I can see the size of the image "(.*?)"$/) do |arg1|
  span = @browser.tr(:class, 'template-download').td(:class, 'size').span
  expect(span.text).to eq('3.52 KB')
end