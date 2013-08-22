# encoding: utf-8

Angenommen(/^es gibt Daten wie im File "(.*)"$/) do |filename|
  ExampleDataProcessor.populate customers: filename
end

Und(/^ich mich für den Kunden "(.*?)" entscheide und auf "(.*?)" klicke$/) do |name,link|
  @browser.h3(:text,name).parent.parent.link(:text,'Edit').click
end

Und(/^ich auf den roten Button zum Entfernen von Avatar klicke$/) do
  @browser.td(:class,'delete').button.click
end

Dann(/^ist auf der Index-Seite die Icon des Kunden "(.*?)" verschwunden$/) do |name|
  @browser.link(:text, 'Customer').click
  @browser.link(:text, 'All customers').click
  @browser.h3(:text,name).parent.div(:class,'pic').img.should_not be_present
end
