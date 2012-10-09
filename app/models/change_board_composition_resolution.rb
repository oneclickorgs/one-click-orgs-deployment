class ChangeBoardCompositionResolution < ResolutionWrapper
  attr_accessor :max_user_directors, :max_employee_directors, :max_supporter_directors,
    :max_producer_directors, :max_consumer_directors

  def after_initialize
    [
      :max_user_directors, :max_employee_directors, :max_supporter_directors, :max_producer_directors, :max_consumer_directors
    ].each do |clause_name|
      send("#{clause_name}=", organisation.constitution.send(clause_name)) unless send(clause_name)
    end
  end

  def attributes_for_resolutions
    result = []
    [:user, :employee, :supporter, :producer, :consumer].each do |member_type|
      method = "max_#{member_type}_directors"
      if organisation.send(method) != send(method).to_i
        result.push({
          :relation => :change_integer_resolutions,
          :name => method,
          :value => send(method).to_i,
          :title => "Allow a maximum of #{send(method)} #{member_type.to_s.titlecase} Members on the Board"
        })
      end
    end
    result
  end
end
