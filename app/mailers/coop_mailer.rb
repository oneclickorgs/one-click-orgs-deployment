class CoopMailer < OcoMailer
  def notify_creation(administrator, coop)
    default_url_options[:host] = Setting[:signup_domain]

    @administrator = administrator
    @coop = coop

    create_mail(
      "OCO",
      administrator.email,
      "A new draft co-op has been created: '#{@coop.name}'"
    )
  end

  def notify_proposed(administrator, coop)
    default_url_options[:host] = Setting[:signup_domain]

    @administrator = administrator
    @coop = coop

    create_mail(
      "OCO",
      administrator.email,
      "A co-op has been submitted for registration '#{@coop.name}'"
    )
  end

  def notify_founded(member, coop)
    default_url_options[:host] = coop.domain(:only_host => true)

    @member = member
    @coop = coop

    create_mail(
      coop.name,
      member.email,
      "The registration of '#{coop.name}' is now complete"
    )
  end
end
