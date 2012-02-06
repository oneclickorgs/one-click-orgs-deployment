class MemberMailerObserver < ActiveRecord::Observer
  observe :member
  
  def after_create(member)
    send_welcome_if_requested(member)
  end
  
  def after_transition(member, transition)
    case transition.event
    when :reactivate
      send_welcome_if_requested(member)
    when :resign
      member.organisation.members.active.each do |recipient|
        MembersMailer.notify_resignation(recipient, member).deliver
      end
    end
  end
  
  def send_welcome_if_requested(member)
    if member.send_welcome
      MembersMailer.send(member.organisation.welcome_email_action, member).deliver
    end
  end
end
