def set_up_app
  Setting[:base_domain] ||= "oneclickorgs.com"
  Setting[:signup_domain] ||= "signup.oneclickorgs.com"
end

def default_organisation(attributes={})
  set_up_app
  
  unless @organisation
    @organisation = Organisation.make({:state => 'active'}.merge(attributes))
    Organisation.stub!(:find_by_host).and_return(@organisation)
  end
  @organisation
end

def default_association(attributes={})
  set_up_app
  
  unless @organisation
    @organisation = Association.make({:state => 'active'}.merge(attributes))
    Organisation.stub!(:find_by_host).and_return(@organisation)
  end
  @organisation
end

def default_company(attributes={})
  set_up_app
  
  unless @organisation
    @organisation = Company.make({:state => 'active'}.merge(attributes))
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
  if @organisation
    @organisation.update_attribute(:state, 'pending')
  else
    default_organisation(:state => 'pending')
  end
  @organisation
end

def organisation_is_proposed
  if @organisation
    @organisation.update_attribute(:state, 'proposed')
  else
    default_organisation(:state => 'proposed')
  end
  @organisation
end

def organisation_is_active
  if @organisation
    @organisation.update_attribute(:state, 'active')
  else
    default_organisation(:state => 'active')
  end
  @organisation
end
