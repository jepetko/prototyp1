class RenameCountryiso < ActiveRecord::Migration
  def change
    rename_column :customers, :countryiso, :country
  end
end
