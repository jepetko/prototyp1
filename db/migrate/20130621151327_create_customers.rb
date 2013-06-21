class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :name
      t.string :street
      t.string :zip
      t.string :city
      t.string :countryiso

      t.timestamps
    end
  end
end
