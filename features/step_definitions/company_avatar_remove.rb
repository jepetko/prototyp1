# encoding: utf-8

Angenommen(/^es gibt Daten wie im File "(.*)"$/) do |filename|
  #Rake::Task['db:populate_customers_csv'].invoke
end

Und(/^ich mich für den Kunden mit dem Namen "(.*?)" entscheide und auf "(.*?)" klicke$/) do |name,link|
  h3 = @browser.div(:class,'thumbnail').h3(:xpath, "h3[text()==\"#{name}\"]")
end

Und(/^ich auf den roten Button zum Entfernen von Avatar klicke$/) do
  pending # express the regexp above with the code you wish you had
end

Dann(/^ist die Icon verschwunden$/) do
  pending # express the regexp above with the code you wish you had
end

Und(/^bei F(\d+) scheint die Icon auch nicht mehr auf$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end
