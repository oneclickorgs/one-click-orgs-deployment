class ShareTransaction < ActiveRecord::Base
  attr_accessible :from_account, :to_account, :amount

  state_machine :initial => :pending do
    event :approve do
      transition :pending => :approved
    end

    after_transition :pending => :approved, :do => :adjust_accounts


    store_audit_trail
  end

  belongs_to :from_account, :class_name => 'ShareAccount'
  belongs_to :to_account, :class_name => 'ShareAccount'

  validates_presence_of :from_account, :to_account, :amount

  def adjust_accounts
    transaction do
      # TODO Use SQL to adjust column value directly, rather than a read + write.
      from_account.update_attribute(:balance, from_account.balance - amount)
      to_account.update_attribute(:balance, to_account.balance + amount)
      from_account.save!
      to_account.save!
    end
  end

  def self.run_daily_job
    # Find withdrawals more than three months old. We can tell a withdrawal from
    # an application by the account the shares are moving to; in a withdrawal,
    # the shares are withdrawn from a member's account, and placed into the
    # organisation's account.
    due_withdrawals = where(["created_at < ?", 3.months.ago]).select{|st| st.to_account.owner.is_a?(Organisation)}
    due_withdrawals.each do |st|
      secretary = st.to_account.owner.secretary
      if secretary
        secretary.tasks.create(:subject => st, :action => :mark_payment_sent)
      end
    end
  end
end
