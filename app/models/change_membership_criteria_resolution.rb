class ChangeMembershipCriteriaResolution < ResolutionWrapper
  attr_accessor :user_members, :employee_members, :supporter_members, :producer_members, :consumer_members

  def after_initialize
    [
      :user_members, :employee_members, :supporter_members, :producer_members, :consumer_members
    ].each do |clause_name|
      send("#{clause_name}=", !!organisation.constitution.send(clause_name) ? '1' : '0') unless send(clause_name)
    end
  end

  def attributes_for_resolutions
    result = []
    [:user, :employee, :supporter, :producer, :consumer].each do |member_type|
      method = member_type.to_s + '_members'
      if send(method) == '1'
        new_value = true
        title = "Change the Rules to allow #{member_type.to_s.titlecase} Members"
      else
        new_value = false
        title = "Change the Rules to disallow #{member_type.to_s.titlecase} Members"
      end
      if (organisation.send(method) && !new_value) || (!organisation.send(method) && new_value)
        result.push({
          :relation => :change_boolean_resolutions,
          :title => title,
          :name => method,
          :value => new_value
        })
      end
    end
    result
  end
end
