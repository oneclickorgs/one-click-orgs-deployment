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
    case organisation
    when Association
      build_proposals_for_association
    when Coop
      build_proposals_for_coop
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

protected

  def build_proposals_for_association
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
  end

  def build_proposals_for_coop
    # Organisation name
    if organisation.name != organisation_name
      proposal = (organisation.change_text_resolutions.build(
        :name => 'organisation_name',
        :value => organisation_name,
        :draft => true
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
      proposal = (organisation.change_text_resolutions.build(
        :name => 'organisation_objectives',
        :value => objectives,
        :title => "Change objects to '#{objectives}'",
        :draft => true
      ))
      proposal.proposer = proposer
      if proposal.valid?
        proposals.push(proposal)
      else
        errors.add(:objectives, proposal.errors.full_messages.to_sentence)
      end
    end

    # Registered office address
    if organisation.registered_office_address != registered_office_address
      proposal = (organisation.change_text_resolutions.build(
        :name => 'registered_office_address',
        :value => registered_office_address,
        :draft => true
      ))
      proposal.proposer = proposer
      if proposal.valid?
        proposals.push(proposal)
      else
        errors.add(:registered_office_address, proposal.errors.full_messages.to_sentence)
      end
    end

    # Member types

    if user_members == '1'
      title = "Change the Rules to allow User Members"
      new_user_members_value = true
    else
      title = "Change the Rules to disallow User Members"
      new_user_members_value = false
    end
    if (organisation.user_members && !new_user_members_value) || (!organisation.user_members && new_user_members_value) # Bit verbose, to cope with null values
      proposal = (organisation.change_boolean_resolutions.new(
        :title => title,
        :name => 'user_members',
        :value => new_user_members_value,
        :draft => true
      ))
      proposal.proposer = proposer
      if proposal.valid?
        proposals.push(proposal)
      else
        errors.add(:user_members, proposal.errors.full_messages.to_sentence)
      end
    end

    if employee_members == '1'
      title = "Change the Rules to allow Employee Members"
      new_employee_members_value = true
    else
      title = "Change the Rules to disallow Employee Members"
      new_employee_members_value = false
    end
    if (organisation.employee_members && !new_employee_members_value) || (!organisation.employee_members && new_employee_members_value) # Bit verbose, to cope with null values
      proposal = (organisation.change_boolean_resolutions.new(
        :title => title,
        :name => 'employee_members',
        :value => new_employee_members_value,
        :draft => true
      ))
      proposal.proposer = proposer
      if proposal.valid?
        proposals.push(proposal)
      else
        errors.add(:employee_members, proposal.errors.full_messages.to_sentence)
      end
    end

    if supporter_members == '1'
      title = "Change the Rules to allow Supporter Members"
      new_supporter_members_value = true
    else
      title = "Change the Rules to disallow Supporter Members"
      new_supporter_members_value = false
    end
    if (organisation.supporter_members && !new_supporter_members_value) || (!organisation.supporter_members && new_supporter_members_value) # Bit verbose, to cope with null values
      proposal = (organisation.change_boolean_resolutions.new(
        :title => title,
        :name => 'supporter_members',
        :value => new_supporter_members_value,
        :draft => true
      ))
      proposal.proposer = proposer
      if proposal.valid?
        proposals.push(proposal)
      else
        errors.add(:supporter_members, proposal.errors.full_messages.to_sentence)
      end
    end

    if producer_members == '1'
      title = "Change the Rules to allow Producer Members"
      new_producer_members_value = true
    else
      title = "Change the Rules to disallow Producer Members"
      new_producer_members_value = false
    end
    if (organisation.producer_members && !new_producer_members_value) || (!organisation.producer_members && new_producer_members_value) # Bit verbose, to cope with null values
      proposal = (organisation.change_boolean_resolutions.new(
        :title => title,
        :name => 'producer_members',
        :value => new_producer_members_value,
        :draft => true
      ))
      proposal.proposer = proposer
      if proposal.valid?
        proposals.push(proposal)
      else
        errors.add(:producer_members, proposal.errors.full_messages.to_sentence)
      end
    end

    if consumer_members == '1'
      title = "Change the Rules to allow Consumer Members"
      new_consumer_members_value = true
    else
      title = "Change the Rules to disallow Consumer Members"
      new_consumer_members_value = false
    end
    if (organisation.consumer_members && !new_consumer_members_value) || (!organisation.consumer_members && new_consumer_members_value) # Bit verbose, to cope with null values
      proposal = (organisation.change_boolean_resolutions.new(
        :title => title,
        :name => 'consumer_members',
        :value => new_consumer_members_value,
        :draft => true
      ))
      proposal.proposer = proposer
      if proposal.valid?
        proposals.push(proposal)
      else
        errors.add(:consumer_members, proposal.errors.full_messages.to_sentence)
      end
    end

    # Shareholding
    if single_shareholding == '1'
      title = "Change the Rules to permit each Member to hold only one share"
      new_single_shareholding_value = true
    else
      title = "Change the Rules to permit each Member to hold more than one share"
      new_single_shareholding_value = false
    end
    if (organisation.single_shareholding && !new_single_shareholding_value) || (!organisation.single_shareholding && new_single_shareholding_value) # Bit verbose, to cope with null values
      proposal = (organisation.change_boolean_resolutions.new(
        :title => title,
        :name => 'single_shareholding',
        :value => new_single_shareholding_value,
        :draft => true
      ))
      proposal.proposer = proposer
      if proposal.valid?
        proposals.push(proposal)
      else
        errors.add(:single_shareholding, proposal.errors.full_messages.to_sentence)
      end
    end

    # Board composition

    if organisation.max_user_directors != max_user_directors.to_i
      proposal = (organisation.change_integer_resolutions.build(
        :name => 'max_user_directors',
        :value => max_user_directors.to_i,
        :title => "Allow a maximum of #{max_user_directors} User Members on the Board",
        :draft => true
      ))
      proposal.proposer = proposer
      if proposal.valid?
        proposals.push(proposal)
      else
        errors.add(:max_user_directors, proposal.errors.full_messages.to_sentence)
      end
    end

    if organisation.max_employee_directors != max_employee_directors.to_i
      proposal = (organisation.change_integer_resolutions.build(
        :name => 'max_employee_directors',
        :value => max_employee_directors.to_i,
        :title => "Allow a maximum of #{max_employee_directors} Employee Members on the Board",
        :draft => true
      ))
      proposal.proposer = proposer
      if proposal.valid?
        proposals.push(proposal)
      else
        errors.add(:max_employee_directors, proposal.errors.full_messages.to_sentence)
      end
    end

    if organisation.max_supporter_directors != max_supporter_directors.to_i
      proposal = (organisation.change_integer_resolutions.build(
        :name => 'max_supporter_directors',
        :value => max_supporter_directors.to_i,
        :title => "Allow a maximum of #{max_supporter_directors} Supporter Members on the Board",
        :draft => true
      ))
      proposal.proposer = proposer
      if proposal.valid?
        proposals.push(proposal)
      else
        errors.add(:max_supporter_directors, proposal.errors.full_messages.to_sentence)
      end
    end

    if organisation.max_producer_directors != max_producer_directors.to_i
      proposal = (organisation.change_integer_resolutions.build(
        :name => 'max_producer_directors',
        :value => max_producer_directors.to_i,
        :title => "Allow a maximum of #{max_producer_directors} Producer Members on the Board",
        :draft => true
      ))
      proposal.proposer = proposer
      if proposal.valid?
        proposals.push(proposal)
      else
        errors.add(:max_producer_directors, proposal.errors.full_messages.to_sentence)
      end
    end

    if organisation.max_consumer_directors != max_consumer_directors.to_i
      proposal = (organisation.change_integer_resolutions.build(
        :name => 'max_consumer_directors',
        :value => max_consumer_directors.to_i,
        :title => "Allow a maximum of #{max_consumer_directors} Consumer Members on the Board",
        :draft => true
      ))
      proposal.proposer = proposer
      if proposal.valid?
        proposals.push(proposal)
      else
        errors.add(:max_consumer_directors, proposal.errors.full_messages.to_sentence)
      end
    end

    # Ownership
    if common_ownership == '1'
      title = "Change the organisation to be a Common Ownership enterprise"
      new_common_ownership_value = true
    else
      title = "Change the organisation to be a Co-ownership enterprise"
      new_common_ownership_value = false
    end
    if (organisation.common_ownership && !new_common_ownership_value) || (!organisation.common_ownership && new_common_ownership_value) # Bit verbose, to cope with null values
      proposal = (organisation.change_boolean_resolutions.new(
        :title => title,
        :name => 'common_ownership',
        :value => new_common_ownership_value,
        :draft => true
      ))
      proposal.proposer = proposer
      if proposal.valid?
        proposals.push(proposal)
      else
        errors.add(:common_ownership, proposal.errors.full_messages.to_sentence)
      end
    end
  end
end
