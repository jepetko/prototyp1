Given(/^a bunch of customers$/) do
  create_faked_customers
end

When(/^I pick the customer at position "(.*?)" in order to click "(.*?)"$/) do |pos,link|
  grab_customer_from_index_and_click_link pos, link
end

Then(/^I must see a form where I can put contact data$/) do
  expect(page.find_by_id('new_contact').present?).to be_true
end

When(/^I put (.*), (.*), (.*)$/) do |name, phone, note|
  page.find_by_id('new_contact') do |f|
    f.input(:id, 'customer_contact_name').set name
    f.input(:id, 'customer_contact_phone').set phone
    f.input(:id, 'customer_notice').set note
  end
end

Then(/^contact (.*), (.*), (.*) should appear in the table above$/) do |name, phone, note|
  div = page.div(:id, 'contacts')
  expect(div).to have_content(name)
  expect(div).to have_content(phone)
  expect(div).to have_content(note)
end