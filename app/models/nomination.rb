class Nomination < ActiveRecord::Base
  attr_accessible :nominee

  belongs_to :nominee, :class_name => 'Member'

  delegate :name, :to => :nominee
end
