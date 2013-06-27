class AddAttachmentAvatarToCustomers < ActiveRecord::Migration
  def self.up
    change_table :customers do |t|
      t.attachment :avatar
    end
  end

  def self.down
    drop_attached_file :customers, :avatar
  end
end
