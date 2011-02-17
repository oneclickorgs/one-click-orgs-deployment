class ProposalMailer < OcoMailer

  def notify_foundation_proposal(member, proposal)
    default_url_options[:host] = member.organisation.domain(:only_host => true)

    @member = member
    @proposal = proposal
    raise ArgumentError, "need member and proposal" unless @member and @proposal
    @organisation = member.organisation
    @organisation_name = member.organisation.name

    @founder = Member.founders(@organisation).first
    raise ArgumentError, "Organisation has no founder" unless @founder

    create_mail(@organisation_name, @member.email, "Founding Vote for #{@organisation_name}")
  end

  def notify_creation(member, proposal)
    default_url_options[:host] = member.organisation.domain(:only_host => true)

    @member = member
    @proposal = proposal
    raise ArgumentError, "need member and proposal" unless @member and @proposal
    @organisation_name = member.organisation.name

    create_mail(@organisation_name, @member.email, "New proposal: #{@proposal.title}")
  end
end
