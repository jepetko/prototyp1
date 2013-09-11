require 'faker'

namespace :db do
  desc "Fill database with sample data"

  task :populate => :environment do

    Rake::Task['db:reset'].invoke

    make_users
    make_customers
  end
end


def make_users
  admin = User.create!( :name => "Superadmin",
                        :email => "golbang.k@gmail.com",
                        :password => "sup3radM1N",
                        :password_confirmation => "sup3radM1N")
  #admin.toggle!(:admin)

  20.times do |n|
    name = Faker::Name.name
    email = Faker::Internet.email
    password = "s3cr3t_12345"
    User.create!(:name => name, :email => email, :password => password, :password_confirmation => password)
  end
end

def random_coordinate(min, max)
  rand * (max-min) + min
end

def make_customers

  100.times do |n|
    name = Faker::Name.name
    street = Faker::Address.street_address
    zip = Faker::Address.zip_code
    city = Faker::Address.city

    lat = random_coordinate  9.178699028539494, 17.528308403539857
    lon = random_coordinate  46.10966936980434, 49.02909877888059

    point = "POINT(#{lat} #{lon})"
    customer = Customer.create!(:name => name, :street => street, :zip => zip, :city => city, :country => 'Austria', :latlon => point)


    file_name = "#{Rails.root}/lib/assets/images/logo_#{Random.rand(1..25)}.png"
    customer.company_avatar = CompanyAvatar.new
    customer.company_avatar.avatar = File.new(file_name)

    make_contacts customer

    customer.save!
  end
end

def make_contacts(customer)
  count = rand 20
  count.times do
    name = Faker::Name.name
    tel = Faker::PhoneNumber.phone_number
    notice = Faker::Lorem.paragraph rand(5)
    customer.contacts.build(:name => name, :phone => tel, :notice => notice)
  end
end