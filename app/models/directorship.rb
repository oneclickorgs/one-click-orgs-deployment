require 'one_click_orgs/model_wrapper'
require 'active_record/attribute_assignment'
require 'one_click_orgs/cast_to_boolean'

class Directorship < OneClickOrgs::ModelWrapper
  include ActiveRecord::AttributeAssignment
  include OneClickOrgs::CastToBoolean

  attr_accessor :organisation, :elected_on
  attr_reader :member_id, :certification

  def member_id=(new_member_id)
    @member_id = new_member_id.to_i
  end

  def certification=(new_certification)
    @certification = cast_to_boolean(new_certification)
  end

  def persisted?
    false
  end

  def save
    member = organisation.members.find(member_id)
    director_member_class = organisation.member_classes.find_by_name('Director')
    member.member_class = director_member_class
    member.save!
    true
  end

  # For ActiveRecord::AttributeAssignment

  def self.attributes_protected_by_default
    []
  end

  def self.reflect_on_aggregation(attribute)
    nil
  end

  def column_for_attribute(attribute)
    case attribute.to_sym
    when :elected_on
      Column.new.tap{|c| c.klass = Date}
    else
      nil
    end
  end

  class Column
    attr_accessor :klass
  end
end
