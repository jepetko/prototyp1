class Contact < ActiveRecord::Base
  attr_accessible :name, :notice, :phone

  validates :name, :presence => true
  validates :phone, :format => { with: /\d+/, message: I18n.t('must_be_a_number') }

  belongs_to :customer, :dependent => :destroy

  validates :customer_id, :presence => true, :numericality => { :greater_than => 0 }
end
