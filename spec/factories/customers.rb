# Read about factories at https://github.com/thoughtbot/factory_girl
require 'faker'

FactoryGirl.define do

 sequence(:customer_name) {|n| "Customer #{n}"}

 factory :customer do
    name { FactoryGirl.generate(:customer_name) }
    street "Funny Street"
    zip "1111"
    city "Funny City"
    country "United States"
    latlon "POINT(#{Faker::Address.latitude} #{Faker::Address.longitude})"
  end

end
