class CoopMailerObserver < ActiveRecord::Observer
  observe :coop

  def after_create(coop)
    send_created_notification(coop)
  end

  def after_transition(coop, transition)
    case transition.event
    when :propose
      send_proposed_notification(coop)
    when :found
      send_founded_notification(coop)
    end
  end

private

  def send_created_notification(coop)
    Administrator.all.each do |administrator|
      CoopMailer.notify_creation(administrator, coop).deliver
    end
  end

  def send_proposed_notification(coop)
    Administrator.all.each do |administrator|
      CoopMailer.notify_proposed(administrator, coop).deliver
    end
  end

  def send_founded_notification(coop)
    coop.members.active.each do |member|
      CoopMailer.notify_founded(member, coop).deliver
    end
  end

end
