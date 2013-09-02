class Customer < ActiveRecord::Base

  set_rgeo_factory_for_column(:latlon,
                              RGeo::Geographic.spherical_factory(:srid => 4326))

  attr_accessible :city, :country, :name, :street, :zip, :company_avatar

  validates :name, :presence => true, :uniqueness => true
  validates :street, :presence => true
  validates :city, :presence => true
  validates :zip, :presence => true
  validates :country, :presence => true
  validates :latlon, :presence => true

  has_one :company_avatar, :dependent => :destroy, :autosave => true
  has_many :contacts, :dependent => :destroy, :autosave => true

end
