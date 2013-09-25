class Customer < ActiveRecord::Base

  def self.factory
    RGeo::Geographic.spherical_factory(:srid => 4326)
  end

  set_rgeo_factory_for_column(:latlon, self.factory)

  attr_accessible :city, :country, :name, :street, :zip, :latlon, :company_avatar

  validates :name, :presence => true, :uniqueness => true
  validates :street, :presence => true
  validates :city, :presence => true
  validates :zip, :presence => true
  validates :country, :presence => true
  validates :latlon, :presence => true

  has_one :company_avatar, :dependent => :destroy, :autosave => true
  has_many :contacts, :dependent => :destroy, :autosave => true

  def self.find_by_keyword(keyword)
    Customer.where('name LIKE ?', "%#{keyword}%").includes(:company_avatar)
  end

  def self.find_by_geom(geom)
    parser = RGeo::WKRep::WKTParser.new(nil, :support_ewkt => true)
    polygon = parser.parse(geom)
    Customer.where{st_intersects(:latlon, polygon)}
  end

end
