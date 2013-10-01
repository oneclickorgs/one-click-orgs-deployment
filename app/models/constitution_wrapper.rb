require 'one_click_orgs/model_wrapper'
require 'one_click_orgs/cast_to_boolean'

class ConstitutionWrapper < OneClickOrgs::ModelWrapper
  include OneClickOrgs::CastToBoolean

  attr_accessor :constitution

  attr_accessor :organisation_name, :objectives, :assets,
    :general_voting_system, :membership_voting_system, :constitution_voting_system,
    :voting_period,
    :registered_office_address, # Coop clauses
    :user_members, :employee_members, :supporter_members, :producer_members, :consumer_members,
    :producer_members_description, :consumer_members_description,
    :single_shareholding,
    :max_user_directors, :max_employee_directors, :max_supporter_directors, :max_producer_directors, :max_consumer_directors,
    :common_ownership

  def after_initialize
    # TODO ? only use constitution's original values as defaults; allow
    # new values to be passed in via the attributes
    case organisation
    when Association
      [:organisation_name, :objectives, :voting_period].each do |clause_name|
        send("#{clause_name}=", constitution.send(clause_name))
      end
      [:general, :membership, :constitution].each do |voting_system_type|
        send(
          "#{voting_system_type}_voting_system=",
          constitution.voting_system(voting_system_type).simple_name
        )
      end
      self.assets = !!constitution.assets ? '1' : '0'
    when Coop
      [
        :organisation_name, :objectives, :registered_office_address,
        :max_user_directors, :max_employee_directors, :max_supporter_directors, :max_producer_directors, :max_consumer_directors,
        :producer_members_description, :consumer_members_description
      ].each do |clause_name|
        send("#{clause_name}=", constitution.send(clause_name))
      end
      [
        :user_members, :employee_members, :supporter_members, :producer_members, :consumer_members,
        :single_shareholding, :common_ownership
      ].each do |clause_name|
        send("#{clause_name}=", !!constitution.send(clause_name) ? '1' : '0')
      end
    end
  end

  def update_attributes(options={})
    case organisation
    when Association
      organisation.clauses.set_text!('organisation_name', options[:organisation_name]) if organisation_name != options[:organisation_name]

      organisation.clauses.set_text!('organisation_objectives', options[:objectives]) if objectives != options[:objectives]

      if options[:assets] == '1'
        new_assets_value = true
      else
        new_assets_value = false
      end
      if (cast_to_boolean(assets) && !new_assets_value) || (!cast_to_boolean(assets) && new_assets_value)
        organisation.clauses.set_boolean!('assets', new_assets_value)
      end

      if general_voting_system != VotingSystems.get(options[:general_voting_system])
        constitution.change_voting_system('general', options[:general_voting_system])
      end
      if constitution_voting_system != VotingSystems.get(options[:constitution_voting_system])
        constitution.change_voting_system('constitution', options[:constitution_voting_system])
      end
      if membership_voting_system != VotingSystems.get(options[:membership_voting_system])
        constitution.change_voting_system('membership', options[:membership_voting_system])
      end

      if voting_period != options[:voting_period].to_i
        constitution.change_voting_period(options[:voting_period].to_i)
      end
    when Coop
      organisation.clauses.set_text!('organisation_name', options[:organisation_name]) if organisation_name != options[:organisation_name]
      organisation.clauses.set_text!('organisation_objectives', options[:objectives]) if objectives != options[:objectives]
      organisation.clauses.set_text!('registered_office_address', options[:registered_office_address]) if registered_office_address != options[:registered_office_address]

      if options[:user_members] == '1'
        new_user_members_value = true
      else
        new_user_members_value = false
      end
      if (cast_to_boolean(user_members) && !new_user_members_value) || (!cast_to_boolean(user_members) && new_user_members_value)
        organisation.clauses.set_boolean!('user_members', new_user_members_value)
      end

      if options[:employee_members] == '1'
        new_employee_members_value = true
      else
        new_employee_members_value = false
      end
      if (cast_to_boolean(employee_members) && !new_employee_members_value) || (!cast_to_boolean(employee_members) && new_employee_members_value)
        organisation.clauses.set_boolean!('employee_members', new_employee_members_value)
      end

      if options[:supporter_members] == '1'
        new_supporter_members_value = true
      else
        new_supporter_members_value = false
      end
      if (cast_to_boolean(supporter_members) && !new_supporter_members_value) || (!cast_to_boolean(supporter_members) && new_supporter_members_value)
        organisation.clauses.set_boolean!('supporter_members', new_supporter_members_value)
      end

      if options[:producer_members] == '1'
        new_producer_members_value = true
      else
        new_producer_members_value = false
      end
      if (cast_to_boolean(producer_members) && !new_producer_members_value) || (!cast_to_boolean(producer_members) && new_producer_members_value)
        organisation.clauses.set_boolean!('producer_members', new_producer_members_value)
      end

      if options[:consumer_members] == '1'
        new_consumer_members_value = true
      else
        new_consumer_members_value = false
      end
      if (cast_to_boolean(consumer_members) && !new_consumer_members_value) || (!cast_to_boolean(consumer_members) && new_consumer_members_value)
        organisation.clauses.set_boolean!('consumer_members', new_consumer_members_value)
      end

      organisation.clauses.set_text!('producer_members_description', options[:producer_members_description]) if producer_members_description != options[:producer_members_description]
      organisation.clauses.set_text!('consumer_members_description', options[:consumer_members_description]) if consumer_members_description != options[:consumer_members_description]

      if options[:single_shareholding] == '1'
        new_single_shareholding_value = true
      else
        new_single_shareholding_value = false
      end
      # raise "single_shareholding: #{single_shareholding.inspect}; new_single_shareholding_value: #{new_single_shareholding_value.inspect}"
      if (cast_to_boolean(single_shareholding) && !new_single_shareholding_value) || (!cast_to_boolean(single_shareholding) && new_single_shareholding_value)
        organisation.clauses.set_boolean!('single_shareholding', new_single_shareholding_value)
      end

      organisation.clauses.set_integer!('max_user_directors', options[:max_user_directors].to_i) if max_user_directors != options[:max_user_directors].to_i
      organisation.clauses.set_integer!('max_employee_directors', options[:max_employee_directors].to_i) if max_employee_directors != options[:max_employee_directors].to_i
      organisation.clauses.set_integer!('max_supporter_directors', options[:max_supporter_directors].to_i) if max_supporter_directors != options[:max_supporter_directors].to_i
      organisation.clauses.set_integer!('max_consumer_directors', options[:max_consumer_directors].to_i) if max_consumer_directors != options[:max_consumer_directors].to_i
      organisation.clauses.set_integer!('max_producer_directors', options[:max_producer_directors].to_i) if max_producer_directors != options[:max_producer_directors].to_i

      if options[:common_ownership] == '1'
        new_common_ownership_value = true
      else
        new_common_ownership_value = false
      end
      if (cast_to_boolean(common_ownership) && !new_common_ownership_value) || (!cast_to_boolean(common_ownership) && new_common_ownership_value)
        organisation.clauses.set_boolean!('common_ownership', new_common_ownership_value)
      end
    end

    # TODO return false on errors
    true
  end

  def organisation
    constitution.organisation
  end

  def persisted?
    true
  end
end
