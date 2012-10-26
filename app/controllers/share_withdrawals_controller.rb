class ShareWithdrawalsController < ApplicationController
  def new
    @share_withdrawal = ShareWithdrawal.new
  end

  def create
    @share_withdrawal = ShareWithdrawal.new(params[:share_withdrawal])
    @share_withdrawal.member = current_user
    @share_withdrawal.save!
    redirect_to shares_path
  end
end
