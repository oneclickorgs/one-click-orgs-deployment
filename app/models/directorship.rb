require 'one_click_orgs/model_wrapper'
require 'active_record/attribute_assignment'
require 'one_click_orgs/cast_to_boolean'

class Directorship < OneClickOrgs::ModelWrapper
  include ActiveRecord::AttributeAssignment
  include OneClickOrgs::CastToBoolean

  attr_accessor :organisation, :elected_on, :ended_on, :persisted
  attr_reader :member_id, :certification

  def member_id=(new_member_id)
    @member_id = new_member_id.to_i
    @id = @member_id
  end

  def member_name
    member = organisation.members.find(member_id)
    member.try(:name)
  end

  def certification=(new_certification)
    @certification = cast_to_boolean(new_certification)
  end

  def persisted?
    !!@persisted
  end

  def save
    member = organisation.members.find(member_id)
    if elected_on
      director_member_class = organisation.member_classes.find_by_name('Director')
      member.member_class = director_member_class
    elsif ended_on
      member_member_class = organisation.member_classes.find_by_name('Member')
      member.member_class = member_member_class
    end
    member.save!
    true
  end

  def self.find_by_id(id)
    directorship = nil
    # TODO Should be scoped by organisation
    member = Member.find_by_id(id)
    if member
      directorship = new
      directorship.member_id = member.id
      directorship.organisation = member.organisation
      directorship.persisted = true
    end
    directorship
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
    when :elected_on, :ended_on
      Column.new.tap{|c| c.klass = Date}
    else
      nil
    end
  end

  class Column
    attr_accessor :klass
  end
end
