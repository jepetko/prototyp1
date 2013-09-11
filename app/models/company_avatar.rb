class CompanyAvatar < ActiveRecord::Base

  before_save :default_values

  #paperclip integration
  attr_accessible :avatar
  attr_accessible :customer_id
  has_attached_file :avatar,
                    :styles => { :medium => "300x300>", :thumb => "100x100>" },
                    :default_url => "/assets/:style/missing.jpg",
                    :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
                    :url => "/system/:attachment/:id/:style/:filename"

  belongs_to :customer

  include Rails.application.routes.url_helpers

  def to_jq_upload
    { "files" => [{
        "id" => id,
        "name" => read_attribute(:avatar_file_name),
        "size" => read_attribute(:avatar_file_size),
        "url" => avatar.url(:original),
        "delete_url" => self.customer.nil? ? company_avatar_path(self) : customer_company_avatar_path(self.customer,self),
        "delete_type" => "DELETE",
        "thumbnail_url" => avatar.url(:thumb)
        }]
    }
  end

  private

  def default_values
    self.customer_id ||= 0
  end

end
