class DecisionsController < ApplicationController
  def show
    decision = co.decisions.find(params[:id])
    if decision.proposal.is_a?(Resolution)
      redirect_to resolution_path(decision.proposal)
    else
      redirect_to proposal_path(decision.proposal)
    end
  end
end
