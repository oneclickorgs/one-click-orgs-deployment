class MemberShareAccountObserver < ActiveRecord::Observer
  observe :member

  def after_transition(member, transition)
    case transition.event
    when :resign, :eject
      empty_share_account(member)
    end
  end

protected

  def empty_share_account(member)
    member.share_account.empty! if member.share_account
  end
end
