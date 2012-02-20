class MemberTimestampObserver < ActiveRecord::Observer
  observe :member
  
  def before_save(member)
    # Timestamp terms acceptance
    if member.terms_and_conditions && member.terms_and_conditions != 0 && member.terms_and_conditions != '0'
      member.terms_accepted_at ||= Time.now.utc
    end
  end
  
  def after_transition(member, transition)
    case transition.event
    when :induct
      member.update_attribute(:inducted_at, Time.now.utc)
    end
  end
end
