class ShareTransactionMailerObserver < ActiveRecord::Observer
  observe :share_transaction

  def after_create(share_transaction)
    if share_transaction.from_account.owner.is_a?(Coop) && share_transaction.to_account.owner.is_a?(Member)
      notify_share_application(share_transaction)
    end
  end

protected

  def notify_share_application(share_transaction)
    secretary = share_transaction.from_account.owner.secretary
    return unless secretary

    ShareTransactionMailer.notify_share_application(secretary, share_transaction).deliver
  end
end