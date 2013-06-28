class DropAttachmentAvatarFromCustomers < ActiveRecord::Migration
  def up
    drop_attached_file :customers, :avatar
  end

  def down
    change_table :customers do |t|
      t.attachment :avatar
    end
  end
end
