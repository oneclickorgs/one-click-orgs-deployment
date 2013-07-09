class CoopMailer < OcoMailer
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
