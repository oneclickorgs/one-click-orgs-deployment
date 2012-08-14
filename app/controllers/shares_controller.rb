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

  def edit_minimum_shareholding
    authorize! :update, co
  end

  def update_minimum_shareholding
    authorize! :update, co

    if params[:organisation][:minimum_shareholding].present?
      co.minimum_shareholding = params[:organisation][:minimum_shareholding]
      co.save!
    end

    redirect_to shares_path
  end

  def edit_interest_rate
    authorize! :update, co
  end

  def update_interest_rate
    authorize! :update, co

    if params[:organisation][:interest_rate].present?
      co.interest_rate = params[:organisation][:interest_rate]
      co.save!
    end

    redirect_to shares_path
  end
end
