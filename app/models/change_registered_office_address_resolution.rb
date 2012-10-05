class ChangeRegisteredOfficeAddressResolution < ResolutionWrapper
  attr_accessor :registered_office_address

  def after_initialize
    self.registered_office_address = organisation.registered_office_address unless registered_office_address
  end

  def attributes_for_resolutions
    [{
      :relation => :change_text_resolutions,
      :name => 'registered_office_address',
      :value => registered_office_address
    }]
  end
end
