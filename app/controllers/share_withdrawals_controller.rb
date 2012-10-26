class ShareWithdrawalsController < ApplicationController
  def new
    @share_withdrawal = ShareWithdrawal.new
    @maximum_share_withdrawal = current_user.shares_count - co.minimum_shareholding
  end

  def create
    @share_withdrawal = ShareWithdrawal.new(params[:share_withdrawal])
    @share_withdrawal.member = current_user
    @share_withdrawal.save!
    redirect_to shares_path
  end
end
