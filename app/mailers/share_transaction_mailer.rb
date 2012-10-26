class ShareTransactionMailer < OcoMailer
  def notify_share_application(recipient, share_transaction)
    @recipient = recipient
    @share_transaction = share_transaction

    raise ArgumentError, "recipient and share_transaction must be passed" unless @recipient && @share_transaction

    @applicant = @share_transaction.to_account.owner
    raise ArgumentError, "could not find applicant from share transaction" unless @applicant

    @organisation = @applicant.organisation

    default_url_options[:host] = @organisation.domain(:only_host => true)

    create_mail(@organisation.name, @recipient.email, "#{@applicant.name} made a new application for shares")
  end

  def notify_share_withdrawal(recipient, share_transaction)
    @recipient = recipient
    @share_transaction = share_transaction

    raise ArgumentError, "recipient and share_transaction must be passed" unless @recipient && @share_transaction

    @applicant = @share_transaction.from_account.owner
    raise ArgumentError, "could not find applicant from share transaction" unless @applicant

    @organisation = @applicant.organisation

    default_url_options[:host] = @organisation.domain(:only_host => true)

    create_mail(@organisation.name, @recipient.email, "#{@applicant.name} applied to withdraw shares")
  end
end
