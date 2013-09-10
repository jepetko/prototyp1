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
  @browser.button(:text, 'New contact').click
  Watir::Wait.until {
    @browser.form(:id, 'new_contact' ).present?
  }
end

When(/^I put (.*), (.*), (.*)$/) do |name, phone, note|
  f = @browser.form(:id,'new_contact')
  f.text_field(:id, 'contact_name').set name
  f.text_field(:id, 'contact_phone').set phone
  f.text_field(:id, 'contact_notice').set note
end

Then(/^contact (.*), (.*), (.*) should appear in the table above$/) do |name, phone, note|
  div = @browser.div(:id, 'contacts')
  Watir::Wait.until {
    c = @browser.div(:id, 'contacts')
    c.present? && c.text.include?(name)
  }
  expect(div.text).to include(name)
  expect(div.text).to include(phone)
  expect(div.text).to include(note)
end