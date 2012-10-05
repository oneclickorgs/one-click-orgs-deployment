require 'one_click_orgs/model_wrapper'

class ResolutionWrapper < OneClickOrgs::ModelWrapper
  attr_accessor :organisation, :proposer, :draft

  def persisted?
    @resolution && @resolution.persisted?
  end

  def save
    attributes_for_resolutions = self.attributes_for_resolutions
    if attributes_for_resolutions.blank?
      return false
    end

    @resolutions = []
    attributes_for_resolutions.each do |attributes_for_resolution|
      attributes_for_resolution = attributes_for_resolution.with_indifferent_access
      relation = attributes_for_resolution.delete(:relation)
      resolution = organisation.send(relation).build(attributes_for_resolution)
      resolution.draft = draft
      resolution.proposer = proposer
      @resolutions.push(resolution)
    end

    if @resolutions.map(&:valid?).inject(true){|memo, is_valid| memo && is_valid}
      @resolutions.each(&:save!)
      true
    else
      false
    end
  end

  def errors
    @resolution ? @resolution.errors : []
  end

  def creation_success_message
    @resolution ? @resolution.creation_success_message : "The resolution was saved."
  end

  def attributes_for_resolutions
    raise NotImplementedError, "#attributes_for_resolutions must be defined by subclass"
  end
end
