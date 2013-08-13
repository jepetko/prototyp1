require 'faker'
require_relative 'DataFeeder'

module FakedExampleGenerator

  include DataFeeder

  def create_users
    10.times do
      create_user name: Faker::Name.name, email: Faker::Internet.email, password: 's3cr3t_12345', password_confirmation: 's3cr3t_12345'
    end
  end

  def create_customers
    20.times do
      c = create_customer name: Faker::Name.name, street: Faker::Address.street_address, zip: Faker::Address.zip_code, city: Faker::Address.city, country: 'AUT'
      add_avatar c
    end
  end

end