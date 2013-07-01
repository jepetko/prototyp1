class Contact < ActiveRecord::Base
  attr_accessible :name, :notice, :phone

  validates :name, :presence => true
  validates :phone, format: { with: /\d*/, message: "must be a number" }

  belongs_to :customer
end
