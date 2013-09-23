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
  Watir::Wait.until {
    @browser.form(:id,'new_contact').present?
  }
end

When(/^I put (.*), (.*), (.*)$/) do |name, phone, note|
  f = @browser.form(:id,'new_contact')
  f.text_field(:id, 'contact_name').set name
  f.text_field(:id, 'contact_phone').set phone
  f.text_field(:id, 'contact_notice').set note
end

Then(/^contact (.*), (.*), (.*) should appear in the table above$/) do |name, phone, note|

  #TODO: count the rows (=number of contacts)
  #and compare the number with the new count
  Watir::Wait.until {
    @browser.table(:class,'contacts').present?
  }

  tr = @browser.tr(:xpath, '//table[@class="contacts"]/tbody/tr[last()]')
  tr.should be_present

  expect(tr.text).to include(name)
  expect(tr.text).to include(phone)
  expect(tr.text).to include(note)
end

Then(/^a warning appears above the phone input field$/) do
  label = @browser.label(:class, 'tel')
  expect(label).to be_present
  label.attribute_value('error-message').should_not eq('')
end

When(/^the list of contacts is empty$/) do

  table = @browser.div(:xpath, '//table[@class="contacts"]')
  table.should_not be_present

  div = @browser.div(:id, 'contacts')
  expect(div.text).to eq(I18n.t('views.contact.index.message_no_contacts'))
end