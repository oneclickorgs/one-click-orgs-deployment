class MembersMailer < OcoMailer
  def welcome_founder(member)
    default_url_options[:host] = member.organisation.domain(:only_host => true)

    @member = member
    raise ArgumentError, "No member provided" unless @member
    @organisation = member.organisation
    @organisation_name = member.organisation.name

    create_mail(@organisation_name, @member.email, "#{@organisation_name} on One Click Orgs")
  end
  
  def welcome_new_founding_member(member)
    default_url_options[:host] = member.organisation.domain(:only_host => true)

    @member = member
    raise ArgumentError, "No member provided" unless @member
    @organisation = member.organisation
    @organisation_name = member.organisation.name

    @founder = Member.founders(@organisation).first
    raise ArgumentError, "Organisation has no founder" unless @founder

    create_mail(@organisation_name, @member.email, "Become a founding member of #{@organisation_name}")
  end
  
  def welcome_new_member(member)
    default_url_options[:host] = member.organisation.domain(:only_host => true)

    @member = member
    raise ArgumentError, "No member provided" unless @member
    @organisation_name = member.organisation.name

    create_mail(@organisation_name, @member.email, "Invitation to become a member of #{@organisation_name}")
  end
  
  def password_reset(member)
    default_url_options[:host] = member.organisation.domain(:only_host => true)
    
    @member = member
    raise ArgumentError, "No member provided" unless @member
    @organisation_name = member.organisation.name

    create_mail(@organisation_name, @member.email, "Your password for #{@organisation_name} on One Click Orgs")
  end
  
  def notify_resignation(recipient, resignee)
    default_url_options[:host] = recipient.organisation.domain(:only_host => true)
    
    @recipient = recipient
    @resignee = resignee
    
    @organisation_name = recipient.organisation.name
    
    create_mail(@organisation_name, @recipient.email, "#{@resignee.name} has resigned")
  end
end
