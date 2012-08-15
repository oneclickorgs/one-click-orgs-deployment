class ShareTransactionTaskObserver < ActiveRecord::Observer
  observe :share_transaction

  def after_create(share_transaction)
    if share_transaction.from_account.owner.is_a?(Coop) && share_transaction.to_account.owner.is_a?(Member)
      create_tasks_for_share_application(share_transaction)
    end
  end

protected

  def create_tasks_for_share_application(share_transaction)
    create_member_task_for_share_application(share_transaction)
    create_secretary_task_for_share_application(share_transaction)
  end

  def create_member_task_for_share_application(share_transaction)
    member = share_transaction.to_account.owner
    member.tasks.create(:subject => share_transaction, :action => :make_payment)
  end

  def create_secretary_task_for_share_application(share_transaction)
    secretary = share_transaction.from_account.owner.secretary
    return unless secretary

    secretary.tasks.create(:subject => share_transaction, :action => :mark_payment_received)
  end
end
