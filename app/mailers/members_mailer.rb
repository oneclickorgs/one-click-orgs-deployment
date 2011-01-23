class MembersMailer < OcoMailer
  def welcome_founder(member)
    default_url_options[:host] = member.organisation.domain(:only_host => true)

    @member = member
    raise ArgumentError, "No member provided" unless @member
    @organisation = member.organisation
    @organisation_name = member.organisation.name

    mail(:to => @member.email, :subject => "#{@organisation_name} on One Click Orgs", :from => "\"#{@organisation_name}\" <notifications@oneclickorgs.com>")
  end
  
  def welcome_new_founding_member(member)
    default_url_options[:host] = member.organisation.domain(:only_host => true)

    @member = member
    raise ArgumentError, "No member provided" unless @member
    @organisation = member.organisation
    @organisation_name = member.organisation.name

    @founder = Member.founder(@organisation)
    raise ArgumentError, "Organisation has no founder" unless @founder

    mail(:to => @member.email, :subject => "Draft constitution for #{@organisation_name} on One Click Orgs", :from => "\"#{@organisation_name}\" <notifications@oneclickorgs.com>")
  end
  
  def welcome_new_member(member)
    default_url_options[:host] = member.organisation.domain(:only_host => true)

    @member = member
    raise ArgumentError, "No member provided" unless @member
    @organisation_name = member.organisation.name

    mail(:to => @member.email, :subject => "Welcome to #{@organisation_name} on One Click Orgs", :from => "\"#{@organisation_name}\" <notifications@oneclickorgs.com>")
  end
  
  def password_reset(member)
    default_url_options[:host] = member.organisation.domain(:only_host => true)
    
    @member = member
    raise ArgumentError, "No member provided" unless @member
    @organisation_name = member.organisation.name

    mail(:to => @member.email, :subject => "Your password for #{@organisation_name} on One Click Orgs", :from => "\"#{@organisation_name}\" <notifications@oneclickorgs.com")
  end
end
