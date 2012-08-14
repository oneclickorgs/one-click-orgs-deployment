class SharesController < ApplicationController
  def index
  end

  def edit_share_value
    authorize! :update, co
  end

  def update_share_value
    authorize! :update, co

    if params[:organisation][:share_value_in_pounds].present?
      co.share_value_in_pounds = params[:organisation][:share_value_in_pounds]
      co.save!
    end

    redirect_to shares_path
  end
end
