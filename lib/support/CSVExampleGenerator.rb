require 'csv'
require_relative 'DataFeeder'

module CSVExampleGenerator

  include DataFeeder

  def create_users(file)
    CSV.foreach("#{Rails.root}/lib/support/files/#{file}") do |row|
      create_user name: row[0], email: row[1], password: row[2], password_confirmation: row[3]
    end
  end


  def create_customers(file)
    CSV.foreach("#{Rails.root}/lib/support/files/#{file}") do |row|
      c = create_customer name: row[0], street: row[1], zip: row[2], city: row[3], country: row[4], latlon: row[5]
      add_avatar c
    end
  end

end