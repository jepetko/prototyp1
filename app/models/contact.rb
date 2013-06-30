class Contact < ActiveRecord::Base
  attr_accessible :name, :notice, :phone

  validates :name, :presence => true

  belongs_to :customer
end
