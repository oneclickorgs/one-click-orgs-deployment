class ChangeObjectivesResolution < ResolutionWrapper
  attr_accessor :objectives

  def after_initialize
    self.objectives = organisation.objectives unless objectives
  end

  def attributes_for_resolutions
    [{
      :relation => :change_text_resolutions,
      :name => 'organisation_objectives',
      :value => objectives,
      :title => "Change objects to '#{objectives}'"
    }]
  end
end
