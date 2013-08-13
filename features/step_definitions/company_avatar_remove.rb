# encoding: utf-8

Angenommen(/^es gibt Daten wie im File "(.*)"$/) do |filename|
  ExampleDataProcessor.populate customers: filename
end

Und(/^ich mich für den Kunden an der Position "(.*?)" entscheide und auf "(.*?)" klicke$/) do |name,link|
  @browser.div(:class,'thumbnail').link(:text,'Edit').click
end

Und(/^ich auf den roten Button zum Entfernen von Avatar klicke$/) do
  @browser.td(:class,'delete').button.click
end

Dann(/^ist die Icon verschwunden$/) do
  @browser.td(:class,'preview').img.should_not be_present
end

Und(/^bei F5 scheint die Icon auch nicht mehr auf$/) do
  @browser.refresh
  @browser.link(:text,'Avatar').click
  @browser.td(:class,'preview').img.src.should =~ /missing\.jpg/
end
