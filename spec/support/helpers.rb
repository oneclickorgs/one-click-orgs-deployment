def set_up_app
  Setting[:base_domain] ||= "oneclickorgs.com"
  Setting[:signup_domain] ||= "signup.oneclickorgs.com"
end

def default_organisation(attributes={})
  set_up_app
  
  unless @organisation
    @organisation = Organisation.make!({:state => 'active'}.merge(attributes))
    Organisation.stub!(:find_by_host).and_return(@organisation)
  end
  @organisation
end

def default_association(attributes={})
  set_up_app
  
  unless @organisation
    @organisation = Association.make!({:state => 'active'}.merge(attributes))
    Organisation.stub!(:find_by_host).and_return(@organisation)
  end
  @organisation
end

def default_company(attributes={})
  set_up_app
  
  unless @organisation
    @organisation = Company.make!({:state => 'active'}.merge(attributes))
    Organisation.stub!(:find_by_host).and_return(@organisation)
  end
  @organisation
end

def default_association_constitution
  default_association
  @organisation.clauses.set_integer!(:voting_period, 3 * 86400)
end

def default_association_voting_systems
  default_association_constitution
  @organisation.clauses.set_text!(:general_voting_system, 'RelativeMajority')
  @organisation.clauses.set_text!(:constitution_voting_system, 'RelativeMajority')
  @organisation.clauses.set_text!(:membership_voting_system, 'RelativeMajority')
end

def default_association_member_class
  default_association
  @default_member_class ||= @organisation.member_classes.make!(:name => "Clown")
end

def default_company_member_class
  default_company
  @default_member_class ||= @organisation.member_classes.make!(:name => "Director")
end

def default_association_user
  default_association_constitution
  default_association
  @default_user ||= @organisation.members.make!(:member_class => default_association_member_class)
end

def default_company_user
  default_company
  @default_user ||= @organisation.members.make!(:member_class => default_company_member_class)
end

def association_login
  @user = default_association_user
  post "/member_session", {:email => @user.email, :password => "password"}
  @user
end

def company_login
  @user = default_company_user
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

def association_is_pending
  if @organisation
    @organisation.update_attribute(:state, 'pending')
  elsif @association
    @association.update_attribute(:state, 'pending')
  else
    default_association(:state => 'pending')
  end
  @organisation
end

def association_is_proposed
  if @organisation
    @organisation.update_attribute(:state, 'proposed')
  elsif @association
    @association.update_attribute(:state, 'proposed')
  else
    default_association(:state => 'proposed')
  end
  @organisation
end

def association_is_active
  if @organisation
    @organisation.update_attribute(:state, 'active')
  elsif @association
    @association.update_attribute(:state, 'active')
  else
    default_association(:state => 'active')
  end
  @organisation
end

def install_organisation_resolver(organisation)
  view.view_paths.dup.each do |view_path|
    view.view_paths.unshift(
      OneClickOrgs::OrganisationResolver.new(
        view_path.to_path,
        @organisation.class
      )
    )
  end
end

def gravatar_url
  'http://www.gravatar.com/avatar/a3406e66dc2a5e80bbc2fd7d5342cc22?s=24&d=mm'
end
