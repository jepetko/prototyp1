class AddCustomerIdToCompanyAvatar < ActiveRecord::Migration
  def change
    add_column :company_avatars, :customer_id, :integer, :default => 0
  end
end
