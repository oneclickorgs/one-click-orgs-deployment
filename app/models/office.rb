class Office < ActiveRecord::Base
  attr_accessible :organisation_id, :title

  belongs_to :organisation, :class_name => 'Coop', :inverse_of => :offices

  has_one :officership,
    :order => "created_at DESC",
    :conditions => proc{[
      "(ended_on IS NULL OR ended_on > :now) AND officerships.elected_on <= :now",
      {:now => Time.now.utc}
    ]},
    :inverse_of => :office

  has_one :officer, :through => :officership

  validates_presence_of :title
end
