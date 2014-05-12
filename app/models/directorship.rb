require 'one_click_orgs/cast_to_boolean'

class Directorship < ActiveRecord::Base
  include OneClickOrgs::CastToBoolean

  attr_accessible :director, :director_id, :director_attributes,
    :ended_on, :elected_on, :certification

  attr_reader :certification

  belongs_to :organisation
  belongs_to :director, :class_name => 'Member', :inverse_of => :directorships

  accepts_nested_attributes_for :director

  def director_name
    director.try(:name)
  end

  def certification=(new_certification)
    @certification = cast_to_boolean(new_certification)
  end

  def ended?
    ended_on.present?
  end

  before_validation :set_director_organisation
  def set_director_organisation
    if director && director.new_record? && !director.organisation
      director.organisation = organisation
    end
  end

  after_save :set_member_class
  def set_member_class
    return unless director && (elected_on || ended_on)
    if ended_on
      member_member_class = organisation.member_classes.find_by_name('Member')
      director.member_class = member_member_class if member_member_class
    elsif elected_on
      current_member_class = director.member_class

      director_member_class = organisation.member_classes.find_by_name('Director')
      secretary_member_class = organisation.member_classes.find_by_name('Secretary')
      external_director_member_class = organisation.member_classes.find_by_name('External Director')

      return if current_member_class == director_member_class || current_member_class == secretary_member_class || current_member_class == external_director_member_class

      director.member_class = director_member_class if director_member_class
    end
    director.save!
  end

  after_save :end_officership_if_directorship_ended
  def end_officership_if_directorship_ended
    return unless ended_on && ended_on_changed?
    return unless director && director.officership
    director.officership.end!
  end

  def self.most_recent
    order('elected_on DESC').first
  end
end
