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

    mail(:to => @member.email, :subject => "Founding Vote for #{@organisation_name}", :from => "\"#{@organisation_name}\" <notifications@oneclickorgs.com>")
  end

  def notify_creation(member, proposal)
    default_url_options[:host] = member.organisation.domain(:only_host => true)

    @member = member
    @proposal = proposal
    raise ArgumentError, "need member and proposal" unless @member and @proposal
    @organisation_name = member.organisation.name

    mail(:to => @member.email, :subject => "New proposal: #{@proposal.title}", :from => "\"#{@organisation_name}\" <notifications@oneclickorgs.com>")
  end
end
