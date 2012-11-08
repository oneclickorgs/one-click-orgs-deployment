class SharesController < ApplicationController
  def index
    @tasks = current_user.tasks.current.shares_related
    @members = co.members.order('last_name ASC, first_name ASC')
    if can?(:read, ShareTransaction)
      # A 'share withdrawal' is when a member withdraws shares from their
      # personal account, returning them to the organisation in exchange
      # for their monetary value. So, from the organisation's point of
      # view, these are deposits.
      @organisation_share_withdrawals = co.deposits

      @organisation_share_applications = co.withdrawals.pending
    end
    @user_share_withdrawals_pending = current_user.find_or_build_share_account.withdrawals.pending
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
