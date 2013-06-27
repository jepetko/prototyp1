# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  sequence(:email) {|n| "email#{n}@factory.com" }

  factory :user do
    name 'User'
    email { FactoryGirl.generate(:email) }
    password "foobar1234"
    password_confirmation "foobar1234"
  end
end