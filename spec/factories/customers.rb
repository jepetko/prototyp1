# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

 sequence(:customer_name) {|n| "Customer #{n}"}

 factory :customer do
    name { FactoryGirl.generate(:customer_name) }
    street "Funny Street"
    zip "1111"
    city "Funny City"
    country "USA"
  end

end
