class Contact < ActiveRecord::Base
  attr_accessible :name, :notice, :phone

  belongs_to :customer
end
