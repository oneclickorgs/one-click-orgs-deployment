require 'one_click_orgs/model_wrapper'

# Provides an ActiveModel like interface to a bundle of ConstitutionProposals.
# The attributes exposed are the constitution settings themselves (e.g. organisation_name,
# voting_period, etc.), plus a single 'proposer' attribute.
class ConstitutionProposalBundle < OneClickOrgs::ModelWrapper
  attr_accessor :organisation,
    :organisation_name,
    :objectives,
    :assets,
    :general_voting_system,
    :membership_voting_system,
    :constitution_voting_system,
    :voting_period,
    :proposer,
    :proposals,
    :registered_office_address, # Coop clauses
    :user_members, :employee_members, :supporter_members, :producer_members, :consumer_members,
    :single_shareholding,
    :max_user_directors, :max_employee_directors, :max_supporter_directors, :max_producer_directors, :max_consumer_directors,
    :common_ownership

  
  def after_initialize
    # Load existing settings from organisation, if given, but don't
    # overwrite new settings that have been passed directly in as attributes.
    if organisation
      case organisation
      when Association
        [:organisation_name, :objectives, :voting_period].each do |clause_name|
          send("#{clause_name}=", organisation.constitution.send(clause_name)) unless send("#{clause_name}")
        end
        [:general, :membership, :constitution].each do |voting_system_type|
          send("#{voting_system_type}_voting_system=", organisation.constitution.voting_system(voting_system_type).simple_name) unless send("#{voting_system_type}_voting_system")
        end
        self.assets = (!!organisation.constitution.assets ? '1' : '0') unless assets
      when Coop
        [
          :organisation_name, :objectives, :registered_office_address,
          :max_user_directors, :max_employee_directors, :max_supporter_directors, :max_producer_directors, :max_consumer_directors
        ].each do |clause_name|
          send("#{clause_name}=", organisation.constitution.send(clause_name)) unless send(clause_name)
        end
        [
          :user_members, :employee_members, :supporter_members, :producer_members, :consumer_members,
          :single_shareholding,
          :common_ownership
        ].each do |clause_name|
          send("#{clause_name}=", !!organisation.constitution.send(clause_name) ? '1' : '0') unless send(clause_name)
        end
      end
    end
    
    self.proposals ||= []
  end
  
  def save
    
    # Organisation name
    if organisation.name != organisation_name
      proposal = (organisation.change_text_proposals.new(
        :name => 'organisation_name',
        :value => organisation_name
      ))
      proposal.proposer = proposer
      if proposal.valid?
        proposals.push(proposal)
      else
        errors.add(:organisation_name, proposal.errors.full_messages.to_sentence)
      end
    end
    
    # Objectives
    if organisation.objectives != objectives
      proposal = (organisation.change_text_proposals.new(
        :name => 'organisation_objectives',
        :value => objectives
      ))
      proposal.proposer = proposer
      if proposal.valid?
        proposals.push(proposal)
      else
        errors.add(:objectives, proposal.errors.full_messages.to_sentence)
      end
    end
    
    # Assets
    if assets == '1'
      title = "Change the constitution to allow holding, transferral and disposal of material assets and intangible assets"
      new_assets_value = true
    else
      title = "Change the constitution to prohibit holding, transferral or disposal of material assets and intangible assets"
      new_assets_value = false
    end
   
    if (organisation.assets && !new_assets_value) || (!organisation.assets && new_assets_value) # Bit verbose, to cope with null values
      proposal = (organisation.change_boolean_proposals.new(
        :title => title,
        :name => 'assets',
        :value => new_assets_value
      ))
      proposal.proposer = proposer
      if proposal.valid?
        proposals.push(proposal)
      else
        errors.add(:assets, proposal.errors.full_messages.to_sentence)
      end
    end
    
    # General voting system
    proposed_system = VotingSystems.get(general_voting_system)
    current_system = organisation.constitution.voting_system :general
    
    if current_system != proposed_system
      proposal = (organisation.change_voting_system_proposals.new(
        :proposal_type => 'general',
        :proposed_system => proposed_system.simple_name
      ))
      proposal.proposer = proposer
      if proposal.valid?
        proposals.push(proposal)
      else
        errors.add(:general_voting_system, proposal.errors.full_messages.to_sentence)
      end
    end
    
    # Membership voting system
    proposed_system = VotingSystems.get(membership_voting_system)
    current_system = organisation.constitution.voting_system :membership
    
    if current_system != proposed_system
      proposal = (organisation.change_voting_system_proposals.new(
        :proposal_type => 'membership',
        :proposed_system => proposed_system.simple_name
      ))
      proposal.proposer = proposer
      if proposal.valid?
        proposals.push(proposal)
      else
        errors.add(:membership_voting_system, proposal.errors.full_messages.to_sentence)
      end
    end
    
    # Constitution voting system
    proposed_system = VotingSystems.get(constitution_voting_system)
    current_system = organisation.constitution.voting_system :constitution
    
    if current_system != proposed_system
      proposal = (organisation.change_voting_system_proposals.new(
        :proposal_type => 'constitution',
        :proposed_system => proposed_system.simple_name
      ))
      proposal.proposer = proposer
      if proposal.valid?
        proposals.push(proposal)
      else
        errors.add(:constitution_voting_system, proposal.errors.full_messages.to_sentence)
      end
    end
    
    # Voting period
    if organisation.constitution.voting_period != voting_period.to_i
      proposal = organisation.change_voting_period_proposals.new(
        :new_voting_period => voting_period
      )
      proposal.proposer = proposer
      if proposal.valid?
        proposals.push(proposal)
      else
        errors.add(:voting_period, proposal.errors.full_messages.to_sentence)
      end
    end
    
    # Early exit?
    if proposals.empty?
      errors.add(:base, "No changes were made")
      return false
    end
    
    # Only save if we have no errors
    if errors.empty?
      proposals.each(&:save!)
      true
    else
      false
    end
  end
  
  def persisted?
    false
  end
end
