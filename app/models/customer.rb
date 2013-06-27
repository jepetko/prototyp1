class Customer < ActiveRecord::Base
  attr_accessible :city, :country, :name, :street, :zip

  validates :name, :presence => true, :uniqueness => true
  validates :street, :presence => true
  validates :city, :presence => true
  validates :zip, :presence => true
  validates :country, :presence => true

  #paperclip integration
  attr_accessible :avatar
  has_attached_file :avatar,
                    :styles => { :medium => "300x300>", :thumb => "100x100>" },
                    :default_url => "/images/:style/missing.png",
                    :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
                    :url => "/system/:attachment/:id/:style/:filename"

end
