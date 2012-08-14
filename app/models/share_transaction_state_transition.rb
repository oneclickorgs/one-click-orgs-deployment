class ShareTransactionStateTransition < ActiveRecord::Base
  belongs_to :share_transaction
  attr_accessible :share_transaction_id, :created_at, :event, :from, :to
end
