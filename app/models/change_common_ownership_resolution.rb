class ChangeCommonOwnershipResolution < ResolutionWrapper
  attr_accessor :common_ownership

  def after_initialize
    self.common_ownership = !!organisation.common_ownership ? '1' : '0' if common_ownership.nil?
  end

  def attributes_for_resolutions
    if common_ownership == '1'
      title = "Change the organisation to be a Common Ownership enterprise"
      new_value = true
    else
      title = "Change the organisation to be a Co-ownership enterprise"
      new_value = false
    end
    if (organisation.common_ownership && !new_value) || (!organisation.common_ownership && new_value)
      [{
        :relation => :change_boolean_resolutions,
        :title => title,
        :name => 'common_ownership',
        :value => new_value
      }]
    else
      nil
    end
  end
end
