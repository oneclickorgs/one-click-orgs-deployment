require 'one_click_orgs/cast_to_boolean'

class Directorship < ActiveRecord::Base
  include OneClickOrgs::CastToBoolean

  attr_accessible :director, :director_id, :ended_on, :elected_on, :certification

  attr_reader :certification

  belongs_to :organisation
  belongs_to :director, :class_name => 'Member'

  def director_name
    director.try(:name)
  end

  def certification=(new_certification)
    @certification = cast_to_boolean(new_certification)
  end

  after_save :set_member_class
  def set_member_class
    return unless director && (elected_on || ended_on)
    if ended_on
      member_member_class = organisation.member_classes.find_by_name('Member')
      director.member_class = member_member_class if member_member_class
    elsif elected_on
      director_member_class = organisation.member_classes.find_by_name('Director')
      director.member_class = director_member_class if director_member_class
    end
    director.save!
  end
end
