class Customer < ActiveRecord::Base
  attr_accessible :city, :country, :name, :street, :zip

  validates :name, :presence => true, :uniqueness => true
  validates :street, :presence => true
  validates :city, :presence => true
  validates :zip, :presence => true
  validates :country, :presence => true
end
