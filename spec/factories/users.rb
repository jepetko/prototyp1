# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name 'User'
    sequence(:email) {|n| "email#{n}@factory.com" }
    password "foobar1234"
    password_confirmation "foobar1234"
  end
end