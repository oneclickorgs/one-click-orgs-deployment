class ChangeNameResolution < ResolutionWrapper
  attr_accessor :organisation_name

  def after_initialize
    self.organisation_name = organisation.name unless organisation_name
  end

  def attributes_for_resolutions
    [{
      :relation => :change_text_resolutions,
      :name => 'organisation_name',
      :value => organisation_name
    }]
  end
end
