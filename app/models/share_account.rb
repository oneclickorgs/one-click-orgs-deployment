class ShareAccount < ActiveRecord::Base
  belongs_to :owner, :polymorphic => true
  has_many :withdrawals, :class_name => 'ShareTransaction', :foreign_key => 'from_account_id'
  has_many :deposits, :class_name => 'ShareTransaction', :foreign_key => 'to_account_id'

  def balance
    self[:balance] || 0
  end

  # If the owner is a Member, immediately withdraw all shares in this
  # account back into the organisation's account.
  def empty!
    return unless owner.is_a?(Member)

    sw = ShareWithdrawal.new(member: owner, amount: balance)
    sw.save!
    sw.approve!
  end
end
