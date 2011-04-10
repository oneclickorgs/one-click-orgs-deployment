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
      create_mail(@organisation_name, @member.email, "Vote passed: #{@organisation_name} has been formed as an Association")
    else
      create_mail(@organisation_name, @member.email, "Vote did not pass: #{@organisation_name} has not been formed as an Association")
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
    create_mail(@organisation_name, @member.email, "Decision for proposal: #{@proposal.title}")
  end
end
