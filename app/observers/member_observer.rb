class MemberObserver < ActiveRecord::Observer
  def after_transition(member, transition)
    case transition.event
    when :resign
      member.resignations.create!
    end
  end
end
