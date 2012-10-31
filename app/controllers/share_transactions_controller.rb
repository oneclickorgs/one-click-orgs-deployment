class ShareTransactionsController < ApplicationController
  def confirm_approve
    find_share_transaction
  end

  def approve
    find_share_transaction
    if can?(:update, @share_transaction)
      if @share_transaction.can_approve?
        @share_transaction.approve!
      end
      if @share_transaction.approved?
        Task.where(:subject_id => @share_transaction.id, :subject_type => 'ShareTransaction').each{|t| t.update_attribute(:completed_at, Time.now.utc)}
      end
      flash[:notice] = "The share transaction was approved."
    end
    redirect_to shares_path
  end

protected

  def find_share_transaction
    @share_transaction = co.share_account.withdrawals.find_by_id(params[:id]) || co.share_account.deposits.find_by_id(params[:id])
    raise NotFound unless @share_transaction
  end
end
