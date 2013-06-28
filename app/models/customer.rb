class Customer < ActiveRecord::Base
  attr_accessible :city, :country, :name, :street, :zip, :company_avatar

  validates :name, :presence => true, :uniqueness => true
  validates :street, :presence => true
  validates :city, :presence => true
  validates :zip, :presence => true
  validates :country, :presence => true

  has_one :company_avatar, :dependent => :destroy, :autosave => true

end
