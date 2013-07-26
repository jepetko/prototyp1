Given(/^a bunch of customers$/) do
  create_faked_customers
end

When(/^I pick the first customer in order to click "(.*?)"$/) do |link|
  grab_customer_from_index_and_click_link link
end

When(/^I click "(.*?)" in browser in order to add a new contact$/) do |link|
  @browser.link(:text, link).click
  Watir::Wait.until {
    @browser.button(:text, 'New contact').present?
  }
end

Then(/^I must see a form where I can put contact data$/) do
  expect(@browser.form(:id,'new_contact').present?).to be_true
end

When(/^I put (.*), (.*), (.*)$/) do |name, phone, note|
  @browser.form(:id,'new_contact') do |f|
    f.input(:id, 'customer_contact_name').set name
    f.input(:id, 'customer_contact_phone').set phone
    f.input(:id, 'customer_notice').set note
  end
end

Then(/^contact (.*), (.*), (.*) should appear in the table above$/) do |name, phone, note|
  div = @browser.div(:id, 'contacts')
  expect(div).to have_content(name)
  expect(div).to have_content(phone)
  expect(div).to have_content(note)
end