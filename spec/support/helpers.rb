def set_up_app
  Setting[:base_domain] ||= "oneclickorgs.com"
  Setting[:signup_domain] ||= "signup.oneclickorgs.com"
end

def default_organisation(attributes={})
  # Organisation is active by default
  active = attributes.include?(:active) ? attributes.delete(:active) : true
  
  set_up_app
  
  unless @organisation
    @organisation = Organisation.make(attributes)
    organisation_is_active if active
    Organisation.stub!(:find_by_host).and_return(@organisation)
  end
  @organisation
end

def default_constitution
  default_organisation
  @organisation.clauses.set_integer!(:voting_period, 3 * 86400)
end

def default_voting_systems
  default_constitution
  @organisation.clauses.set_text!(:general_voting_system, 'RelativeMajority')
  @organisation.clauses.set_text!(:constitution_voting_system, 'RelativeMajority')
  @organisation.clauses.set_text!(:membership_voting_system, 'RelativeMajority')
end

def default_member_class
  default_organisation
  @default_member_class ||= @organisation.member_classes.make(:name => "Clown")
end

def default_user
  default_constitution
  default_organisation
  @default_user ||= @organisation.members.make(:member_class => default_member_class)
end

def login
  @user = default_user
  post "/member_session", {:email => @user.email, :password => "password"}
  @user
end

def set_permission!(user, perm, value)
  user.member_class.set_permission!(perm, value)
end

def passed_proposal(p, args={})
  p.stub!(:passed?).and_return(true)
  p.parameters = args
  lambda { p.enact! }
end

def organisation_is_pending
  default_organisation(:active => false) unless @organisation
  @organisation.clauses.set_text!('organisation_state', "pending")
end

def organisation_is_active
  default_organisation(:active => false) unless @organisation
  @organisation.clauses.set_text!('organisation_state', "active")
  @organisation.should be_active
end

def organisation_is_under_construction
  default_organisation(:active => false) unless @organisation
  clause = @organisation.clauses.get_current('organisation_state')
  clause.destroy if clause
end
