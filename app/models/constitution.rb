# Constitution is a convenience class that provides methods for getting and setting
# constitution-related aspects of an organisation.
# 
# Typically, you'll let your Organisation object set up the Constitution object
# for you, e.g.
# 
#   organisation.constitution.change_voting_system(:general, 'RelativeMajority')
class Constitution

  def initialize(organisation)
    @organisation = organisation
  end
  
  def organisation
    @organisation
  end
  
  delegate :name, :objectives, :assets, :domain,
    :meeting_notice_period, :meeting_notice_period=,
    :quorum_number, :quorum_number=,
    :quorum_percentage, :quorum_percentage=,
    :registered_office_address,
    :user_members, :employee_members, :supporter_members, :producer_members, :consumer_members,
    :producer_members_description, :consumer_members_description,
    :single_shareholding,
    :max_user_directors, :max_employee_directors, :max_supporter_directors, :max_producer_directors, :max_consumer_directors,
    :common_ownership, :to => :organisation
  
  alias_method :organisation_name, :name

  def document
    # TODO Make this work for Organisation subclasses other than Coop.
    if document_id = Setting[:coop_constitution_document_id]
      document = Rticles::Document.find(document_id)
    else
      document = Rticles::Document.where(:title => 'coop_constitution').order('updated_at DESC').first
    end

    raise ActiveRecord::RecordNotFound unless document

    document.insertions = {
      :organisation_name => name,
      :registered_office_address => registered_office_address,
      :objectives => objectives,
      :producer_members_description => producer_members_description,
      :consumer_members_description => consumer_members_description,
      :max_user_directors => max_user_directors,
      :max_employee_directors => max_employee_directors,
      :max_supporter_directors => max_supporter_directors,
      :max_producer_directors => max_producer_directors,
      :max_consumer_directors => max_consumer_directors,
      :meeting_notice_period => meeting_notice_period,
      :quorum_number => quorum_number,
      :quorum_percentage => quorum_percentage
    }
    document.choices = {
      :user_members => user_members,
      :employee_members => employee_members,
      :supporter_members => supporter_members,
      :producer_members => producer_members,
      :consumer_members => consumer_members,
      :single_shareholding => single_shareholding,
      :common_ownership => common_ownership
    }
    document
  end
  
  # VOTING SYSTEMS
  
  def voting_system(type = :general)     
    clause = organisation.clauses.get_current("#{type}_voting_system") 
    raise ArgumentError, "invalid system: #{type}" unless clause && clause.text_value
    VotingSystems.get(clause.text_value)
  end
  
  def set_voting_system(type, new_system)
    raise ArgumentError, "system #{type} not found" unless ['general', 'membership', 'constitution'].include?(type.to_s)
    raise ArgumentError, "invalid voting system: #{new_system}" unless VotingSystems.get(new_system)
    organisation.clauses.set_text!("#{type}_voting_system", new_system)
  end
  
  def change_voting_system(type, new_system)
    raise ArgumentError, "no previous voting system" unless organisation.clauses.currently_exists?("#{type}_voting_system")
    set_voting_system(type, new_system)
  end
  
  # VOTING PERIOD
  
  def voting_period
    organisation.clauses.get_integer('voting_period')
  end
  
  def set_voting_period(new_period)
    raise ArgumentError, "invalid voting period #{new_period}" unless new_period > 0
    organisation.clauses.set_integer!('voting_period', new_period)
  end

  def change_voting_period(new_period)
    raise ArgumentError, "no previous voting period" unless organisation.clauses.currently_exists?('voting_period')
    set_voting_period(new_period)
  end
end
