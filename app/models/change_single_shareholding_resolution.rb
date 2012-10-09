class ChangeSingleShareholdingResolution < ResolutionWrapper
  attr_accessor :single_shareholding

  def after_initialize
    self.single_shareholding = !!organisation.single_shareholding ? '1' : '0' if single_shareholding.nil?
  end

  def attributes_for_resolutions
    if single_shareholding == '1'
      title = "Change the Rules to permit each Member to hold only one share"
      new_value = true
    else
      title = "Change the Rules to permit each Member to hold more than one share"
      new_value = false
    end
    if (organisation.single_shareholding && !new_value) || (!organisation.single_shareholding && new_value)
      [{
        :relation => :change_boolean_resolutions,
        :title => title,
        :name => 'single_shareholding',
        :value => new_value
      }]
    else
      nil
    end
  end
end
