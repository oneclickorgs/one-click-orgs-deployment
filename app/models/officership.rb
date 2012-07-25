require 'one_click_orgs/cast_to_boolean'

# An Officership represents the period during which a particular
# person occupies a particular office.
# 
# Each Office can only have one current Officership, but will have
# a history of many Officerships as different people occupy the
# Office.
# 
# Similarly, a Member can only have one current Officership (i.e.
# they can only occupy one Office at a time). But they may build
# up a history of many Officerships if they occupy several Offices
# in sequence.
class Officership < ActiveRecord::Base
  include OneClickOrgs::CastToBoolean

  attr_accessible :office_id, :office_attributes, :officer_id, :certification, :elected_on

  attr_reader :certification

  belongs_to :office
  belongs_to :officer, :class_name => 'Member'

  accepts_nested_attributes_for :office, :reject_if => :all_blank

  # after_initialize :build_office_if_necessary
  # def build_office_if_necessary
  #   if new_record? && !office
  #     build_office
  #   end
  # end

  def certification=(new_certification)
    @certification = cast_to_boolean(new_certification)
  end

  # This needs to run after validation, not before save, since
  # the organisation gets saved by ActiveRecord between the validation
  # and save steps.
  after_validation :set_organisation_of_new_office_if_necessary
  def set_organisation_of_new_office_if_necessary
    if office && office.new_record? && office.organisation.blank?
      office.organisation = officer.organisation unless officer.blank?
    end
  end
end
