class CompanyAvatar < ActiveRecord::Base

  #paperclip integration
  attr_accessible :avatar
  has_attached_file :avatar,
                    :styles => { :medium => "300x300>", :thumb => "100x100>" },
                    :default_url => "/images/:style/missing.png",
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
        "delete_url" => company_avatar_path(self),
        "delete_type" => "DELETE",
        "thumbnail_url" => avatar.url(:thumb)
        }]
    }
  end

end