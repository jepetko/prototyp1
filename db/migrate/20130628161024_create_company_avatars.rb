class CreateCompanyAvatars < ActiveRecord::Migration
  def change
    create_table :company_avatars do |t|
      t.attachment :avatar

      t.timestamps
    end
  end
end