# A convenience class to allow creation of a Member model object, but using
# 'Director.new' instead of 'Member.new'.
# 
# Adds some director-specific validation
class Director < Member
  @abstract_class = true
  
  attr_accessor :certification
  
  validates_acceptance_of :certification, :on => :create, :allow_nil => false
  
  def send_new_director_notifications
    self.organisation.members.each do |member|
      MembersMailer.notify_new_director(member, self).deliver
    end
  end
  
  def send_stand_down_notification_emails
    self.organisation.members.each do |member|
      MembersMailer.notify_director_stand_down(member, self).deliver
    end
  end
end
