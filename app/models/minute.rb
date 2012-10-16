require 'one_click_orgs/model_wrapper'
require 'active_record/attribute_assignment'

class Minute < OneClickOrgs::ModelWrapper
  include ActiveRecord::AttributeAssignment

  attr_accessor :meeting
  attr_reader :meeting_class

  delegate :organisation, :organisation=,
    :happened_on, :happened_on=,
    :minutes, :minutes=,
    :participant_ids=, :to => :meeting

  MEETING_CLASS_WHITE_LIST = ['Meeting', 'GeneralMeeting', 'AnnualGeneralMeeting', 'BoardMeeting']

  def before_initialize(attributes)
    if meeting = attributes.delete(:meeting)
      self.meeting = meeting
    elsif meeting_class = attributes.delete(:meeting_class)
      self.meeting_class = meeting_class
    else
      self.meeting = Meeting.new
    end
  end

  def persisted?
    meeting ? meeting.persisted? : false
  end

  def meeting_class=(new_meeting_class)
    unless MEETING_CLASS_WHITE_LIST.include?(new_meeting_class.to_s)
      raise "Invalid meeting_class: #{new_meeting_class}"
      return
    end

    @meeting_class = new_meeting_class.to_s
    existing_meeting_attributes = (meeting ? meeting.attributes : {}).with_indifferent_access
    existing_meeting_attributes.delete(:id)
    @meeting = @meeting_class.safe_constantize.new.tap{|m|
      m.agenda_items = []
      existing_meeting_attributes.each do |k, v|
        m.send("#{k}=", v)
      end
    }
  end

  def save
    meeting.save
  end

  # To fake multi-parameter date assignment for 'happened_on' attribute

  def column_for_attribute(attribute)
    case attribute.to_sym
    when :happened_on
      Column.new.tap{|c| c.klass = Date}
    else
      super
    end
  end

  class Column
    attr_accessor :klass
  end

  def self.reflect_on_aggregation(aggregation)
    nil
  end

  def self.primary_key
    'id'
  end

  def self.inheritance_column
    'type'
  end
end
