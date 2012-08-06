class MemberStateTransition < ActiveRecord::Base
  belongs_to :member
  attr_accessible :member_id, :created_at, :event, :from, :to
end
