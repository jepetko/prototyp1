require 'faker'
require_relative 'DataFeeder'

module FakedExampleGenerator

  include DataFeeder

  def create_users
    20.times do |n|
      self.create_user name: Faker::Name.name, email: Faker::Internet.email, password: 's3cr3t_12345', password_confirmation: 's3cr3t_12345'
    end
  end

end