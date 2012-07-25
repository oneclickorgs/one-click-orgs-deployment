class Office < ActiveRecord::Base
  attr_accessible :organisation_id, :title

  belongs_to :organisation, :class_name => 'Coop', :inverse_of => :offices
  has_one :officership, :order => "created_at DESC", :inverse_of => :office
  has_one :officer, :through => :officership

  validates_presence_of :title
end
