require 'one_click_orgs/model_wrapper'

class ConstitutionWrapper < OneClickOrgs::ModelWrapper
  attr_accessor :constitution
  
  attr_accessor :organisation_name, :objectives, :assets,
    :general_voting_system, :membership_voting_system, :constitution_voting_system,
    :voting_period
  
  def after_initialize
    # TODO ? only use constitution's original values as defaults; allow
    # new values to be passed in via the attributes
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
  end
  
  def update_attributes(options={})
    # TODO return false on errors
    
    organisation.clauses.set_text!('organisation_name', options[:organisation_name]) if organisation_name != options[:organisation_name]
    
    organisation.clauses.set_text!('organisation_objectives', options[:objectives]) if objectives != options[:objectives]
    
    if options[:assets] == '1'
      new_assets_value = true
    else
      new_assets_value = false
    end
    if (assets && !new_assets_value) || (!assets && new_assets_value)
      organisation.clauses.set_boolean!('asets', new_assets_value)
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
    
    true
  end
  
  def organisation
    constitution.organisation
  end
  
  def persisted?
    true
  end
end
