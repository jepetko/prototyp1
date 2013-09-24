# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :location do
    street 'Siebenbrunnengasse 44'
    zip '1050'
    city 'Wien'
    country 'Austria'
  end
end
