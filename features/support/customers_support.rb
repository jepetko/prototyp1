require 'faker'
module CustomersSupport

  def create_faked_customers
    10.times do
      FactoryGirl.create(:customer,
                         city: Faker::Address.city,
                         zip: Faker::Address.zip_code,
                         street: Faker::Address.street_address,
                         country: Faker::Address.country,
                         name: Faker::Company.name)
    end
  end

  def create_customers(table)
    table.hashes.each do |rec|
      FactoryGirl.create(:customer, :name => rec[:name])
    end
  end

  def grab_customer_from_index_and_click_link(pos,link)
    page.all(:xpath, "//div[@class=\"thumbnail customer\"]")[pos.to_i].find(:xpath,'./..').click_link(link)
  end
end

World(CustomersSupport)