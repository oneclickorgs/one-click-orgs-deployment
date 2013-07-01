class GeneralMeeting < Meeting
  attr_accessible :start_time, :venue, :agenda, :certification, :existing_resolutions_attributes, :passed_resolutions_attributes,
    :annual_general_meeting, :electronic_nominations, :nominations_closing_date,
    :electronic_voting, :voting_closing_date, :start_time_proxy

  has_many :resolutions, :foreign_key => 'meeting_id'

  attr_accessor :certification, :annual_general_meeting
  attr_accessor :electronic_nominations, :nominations_closing_date,
    :electronic_voting, :voting_closing_date
  attr_reader :start_time_proxy

  after_initialize :after_initialize
  def after_initialize
    if new_record?
      if organisation && organisation.respond_to?(:meeting_notice_period)
        self.happened_on ||= Date.today.advance(:days => organisation.meeting_notice_period)
      end

      if agenda_items.empty?
        [
          "Apologies for Absence",
          "Minutes of Previous Meeting",
          "Any Other Business",
          "Time and date of next meeting"
        ].each_with_index do |title, index|
          agenda_items.build(:title => title, :position => index + 1)
        end
      end
    end
  end

  def existing_resolutions_attributes=(attributes)
    # The attributes received from the form will look something like this:
    # {"0"=>{"attached"=>"1", "id"=>"7"}, "1"=>{"attached"=>"0", "id"=>"9"}}
    #
    # We want to find only the resolutions that have been attached, and
    # grab their IDs.

    return unless attributes.is_a?(Hash)

    ids_to_attach = attributes.values.select{|a| a['attached'] == '1'}.map{|a| a['id'].to_i}

    ids_to_open_for_voting = attributes.values.select{|a| a['open'] == '1'}.map{|a| a['id'].to_i}

    # TODO Resolution search should be scoped by organisation,
    # but organisation is not set yet when building this general meeting
    # in the form @organisation.general_meetings.build(attributes)
    resolutions_to_attach = ids_to_attach.map{|id| Resolution.find_by_id(id)}
    resolutions_to_attach.delete_if(&:nil?)

    resolutions << resolutions_to_attach
    resolutions.each do |resolution|
      if ids_to_open_for_voting.include?(resolution.id)
        resolution.start!
      elsif resolution.draft?
        resolution.attach!
      end
    end

    attributes
  end

  def passed_resolutions_attributes=(attributes)
    @resolutions_to_pass = []
    @resolutions_to_record_additional_votes = []

    attributes.values.each do |v|
      id = v['id'].to_i

      passed = v['passed']

      additional_votes_for = v['additional_votes_for']
      additional_votes_against = v['additional_votes_against']

      if passed == '1'
        resolution = resolutions.find_by_id(id)
        if resolution
          resolution.force_passed = true
          @resolutions_to_pass.push(resolution)
        end
      elsif additional_votes_for.present? && additional_votes_against.present?
        resolution = resolutions.find_by_id(id)
        if resolution
          resolution.additional_votes_for = additional_votes_for.to_i
          resolution.additional_votes_against = additional_votes_against.to_i
          @resolutions_to_record_additional_votes.push(resolution)
        end
      end
    end
  end

  before_save :close_resolutions_to_pass
  def close_resolutions_to_pass
    return if @resolutions_to_pass.blank?

    @resolutions_to_pass.each do |resolution|
      resolution.close!
    end
  end

  before_save :update_resolutions_to_record_additional_votes
  def update_resolutions_to_record_additional_votes
    return if @resolutions_to_record_additional_votes.blank?

    @resolutions_to_record_additional_votes.each do |resolution|
      resolution.save!
      resolution.close!
    end
  end

  def creation_notification_email_action
    :notify_general_meeting_creation
  end

  def members_to_notify
    organisation.members
  end

  def to_event
    {:timestamp => created_at, :object => self, :kind => :general_meeting}
  end

  def self.description
    "General Meeting"
  end

  # To fake multi-parameter date/time assignment for 'nominations_closing_date',
  # 'voting_closing_date' and 'start_time_proxy' attributes

  def column_for_attribute(attribute)
    case attribute.to_sym
    when :nominations_closing_date, :voting_closing_date
      Column.new.tap{|c| c.klass = Date}
    when :start_time_proxy
      Column.new.tap{|c| c.klass = Time}
    else
      super
    end
  end

  class Column
    attr_accessor :klass, :type
  end

  # Pass values set via start_time_proxy into the real start_time attribute

  def start_time_proxy=(time)
    self.start_time = time.strftime("%k:%M")
  end

end
