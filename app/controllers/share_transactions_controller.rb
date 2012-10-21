class ShareTransactionsController < ApplicationController
  def approve
    @share_transaction = co.share_account.withdrawals.find_by_id(params[:id]) || co.share_account.deposits.find_by_id(params[:id])
    if @share_transaction
      if can?(:update, @share_transaction)
        @share_transaction.approve!
        flash[:notice] = "The share transaction was approved."
      end
    end
    redirect_to shares_path
  end
end
