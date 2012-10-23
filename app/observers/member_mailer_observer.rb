class MemberMailerObserver < ActiveRecord::Observer
  observe :member

  def after_create(member)
    case member.organisation
    when Coop
      if member.organisation.active?
        send_new_member_notification(member) if member.pending?
      elsif member.organisation.pending?
        send_welcome_if_requested(member)
      end
    else
      send_welcome_if_requested(member)
    end
  end

  def after_transition(member, transition)
    case transition.event
    when :induct
      case member.organisation
      when Coop
        if member.organisation.active?
          send_welcome_if_requested(member)
        end
      end
    when :reactivate
      send_welcome_if_requested(member)
    when :resign
      case member.organisation
      when Coop
        send_resignation_notification_to_secretary(member)
      else
        member.organisation.members.active.each do |recipient|
          MembersMailer.notify_resignation(recipient, member).deliver
        end
      end
    end
  end

  def send_welcome_if_requested(member)
    if member.send_welcome
      MembersMailer.send(member.organisation.welcome_email_action, member).deliver
    end
  end

  def send_new_member_notification(member)
    secretary = member.organisation.try(:secretary)
    return unless secretary

    MembersMailer.send(:notify_new_member, secretary, member).deliver
  end

  def send_resignation_notification_to_secretary(member)
    secretary = member.organisation.try(:secretary)
    return unless secretary
    MembersMailer.notify_resignation(secretary, member).deliver
  end
end
