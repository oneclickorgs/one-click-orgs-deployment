class DecisionMailer < OcoMailer
  
  def notify_foundation_decision(member, decision)
    default_url_options[:host] = member.organisation.domain(:only_host => true)

    @decision = decision
    @member = member
    raise ArgumentError, "need decision and member" unless @decision and @member
    
    @proposal = @decision.proposal
    raise ArgumentError, "decision has no attached proposal" unless @proposal
    
    @organisation = @proposal.organisation
    raise ArgumentError, "proposal has no attached organisation" unless @organisation
    
    @members = @organisation.members
    @organisation_name = @organisation.name
    @member_vote = @member.votes.first

    if @proposal.passed? then
      mail(:to => @member.email, :subject => "Vote passed: #{@organisation_name} has been formed as an Association", :from => "\"#{@organisation_name}\" <notifications@oneclickorgs.com>")
    else
      mail(:to => @member.email, :subject => "Vote did not pass: #{@organisation_name} has not been formed as an Association", :from => "\"#{@organisation_name}\" <notifications@oneclickorgs.com>")
    end
  end

  def notify_new_decision(member, decision)
    default_url_options[:host] = member.organisation.domain(:only_host => true)

    @decision = decision
    @proposal = @decision.proposal
    @member = member
    
    @organisation_name = member.organisation.name

    raise ArgumentError, "need decision" unless @decision and @member
    raise ArgumentError, "decision has no attached proposal" unless @proposal
    mail(:to => @member.email, :subject => "Decision for proposal: #{@proposal.title}", :from => "\"#{@organisation_name}\" <notifications@oneclickorgs.com>")
  end
end
