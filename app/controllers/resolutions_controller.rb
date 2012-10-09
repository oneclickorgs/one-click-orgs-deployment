class ResolutionsController < ApplicationController
  HANDLED_RESOLUTION_TYPES = [
    :change_meeting_notice_period_resolution,
    :change_quorum_resolution
  ]
  HANDLED_RESOLUTION_WRAPPERS = [
    :change_board_composition_resolution,
    :change_common_ownership_resolution,
    :change_membership_criteria_resolution,
    :change_name_resolution,
    :change_objectives_resolution,
    :change_registered_office_address_resolution,
    :change_single_shareholding_resolution
  ]

  def new
    unless can?(:create, Resolution) || can?(:create, ExtraordinaryResolution)
      redirect_to root_path
      return
    end

    @resolution = co.resolutions.build
  end

  def create
    HANDLED_RESOLUTION_TYPES.each do |resolution_type|
      if params[resolution_type]
        resolution_class = co.send(resolution_type.to_s.pluralize)
        resolution_parameters = params[resolution_type] || {}
        generic_parameters = params[:resolution] || {}
        combined_parameters = resolution_parameters.merge(generic_parameters)
        @resolution = resolution_class.build(combined_parameters)
      end
    end

    HANDLED_RESOLUTION_WRAPPERS.each do |resolution_type|
      if params[resolution_type]
        resolution_class = resolution_type.to_s.classify.constantize
        resolution_parameters = params[resolution_type] || {}
        generic_parameters = params[:resolution] || {}
        combined_parameters = resolution_parameters.merge(generic_parameters)
        @resolution = resolution_class.new(:organisation => co)
        @resolution.attributes = combined_parameters
      end
    end

    # If no special type of resolution found, make a normal resolution
    if !@resolution
      @resolution = current_organisation.resolutions.build(params[:resolution])
    end

    @resolution.draft = true if params[:submit_draft]
    @resolution.proposer = current_user

    if @resolution.save
      flash[:notice] = @resolution.creation_success_message
      redirect_to proposals_path
    else
      raise @resolution.errors.full_messages.inspect
    end
  end

  def show
    @resolution = co.resolutions.find(params[:id])
    @comments = @resolution.comments
    @comment = Comment.new
  end
end
