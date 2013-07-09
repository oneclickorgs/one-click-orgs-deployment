class CoopMailerObserver < ActiveRecord::Observer
  observe :coop

  def after_transition(coop, transition)
    case transition.event
    when :found
      send_founded_notification(coop)
    end
  end

private

  def send_founded_notification(coop)
    coop.members.active.each do |member|
      CoopMailer.notify_founded(member, coop).deliver
    end
  end

end
