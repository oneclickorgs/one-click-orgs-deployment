require 'one_click_orgs/model_wrapper'

# Represents a ShareTransaction that transfers shares from
# the organisation's account to the user's account.
class ShareWithdrawal < OneClickOrgs::ModelWrapper
  attr_accessor :amount, :member, :share_transaction

  def initialize(new_attributes={})
    new_attributes = new_attributes.with_indifferent_access

    self.share_transaction = new_attributes.delete(:share_transaction) || ShareTransaction.new

    new_attributes.each do |k, v|
      self.send("#{k}=", v)
    end
  end

  def member=(new_member)
    member_share_account = new_member.find_or_build_share_account
    organisation_share_account = new_member.organisation.share_account

    share_transaction.from_account = member_share_account
    share_transaction.to_account = organisation_share_account

    @member = new_member
  end

  def amount=(new_amount)
    share_transaction.amount = new_amount
    @amount = new_amount
  end

  def save
    share_transaction.save
  end

  def persisted?
    true
  end
end
