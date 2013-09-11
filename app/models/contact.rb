class Contact < ActiveRecord::Base
  attr_accessible :name, :notice, :phone

  validates :name, :presence => true
  validates :phone, :format => { with: /[\d]+[\s]*/, message: I18n.t('errors.messages.not_a_number') }

  belongs_to :customer

  validates :customer_id, :presence => true, :numericality => { :greater_than => 0 }
end
