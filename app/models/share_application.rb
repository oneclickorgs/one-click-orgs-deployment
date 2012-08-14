require 'one_click_orgs/model_wrapper'

# Represents a ShareTransaction that transfers shares from
# the organisation's account to the user's account.
class ShareApplication < OneClickOrgs::ModelWrapper
  attr_accessor :share_transaction
  attr_reader :member

  delegate :amount, :amount=, :to => :share_transaction

  def initialize(new_attributes={})
    new_attributes = new_attributes.with_indifferent_access

    self.share_transaction = new_attributes.delete(:share_transaction) || ShareTransaction.new

    new_attributes.each do |k, v|
      send("#{k}=", v)
    end
  end

  def member=(new_member)
    @member = new_member
    share_transaction.to_account = @member.find_or_build_share_account
    share_transaction.from_account = @member.organisation.share_account
  end

  def save
    result = share_transaction.save
    raise share_transaction.errors.full_messages.to_sentence unless result
    result
  end

  def persisted?
    share_transaction && share_transaction.persisted?
  end
end
