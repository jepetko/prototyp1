class AddLatlonToCustomer < ActiveRecord::Migration
  def change
    add_column :customers, :latlon, :point, :geographic => true
  end
end
