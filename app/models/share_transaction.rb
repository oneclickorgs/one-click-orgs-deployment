class ShareTransaction < ActiveRecord::Base
  attr_accessible :from_account, :to_account, :amount

  state_machine :initial => :pending do
    event :approve do
      transition :pending => :approved
    end

    store_audit_trail
  end

  belongs_to :from_account, :class_name => 'ShareAccount'
  belongs_to :to_account, :class_name => 'ShareAccount'

  validates_presence_of :from_account, :to_account, :amount
end
