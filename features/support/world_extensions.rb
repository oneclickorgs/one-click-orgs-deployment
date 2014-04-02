module AppSetup
  def set_up_application
    # *.ocolocalhost.com resolves to 127.0.0.1. This lets us test subdomain
    # look-up using domains like 'company.ocolocalhost.com' and
    # 'association.ocolocalhost.com', without having to set up local wildcard
    # entries on each developer's machine and on the CI server.
    #
    # N.B. This means some Cucumber scenarios will fail if your machine
    # isn't connected to the internet. We shoud probably fix this.
    #
    # Port needs to be saved for Selenium tests (because our app code considers
    # the port as well as the hostname when figuring out how to handle a
    # request, and the Capybara app server doesn't run on port 80).
    #
    # When using the rack-test driver, don't use port numbers at all,
    # since it makes our test-session-resetting code (see features/support/capybara_domains.rb)
    # more complicated.
    port_segment = Capybara.current_driver == :selenium ? ":#{Capybara.server_port}" : ''

    Setting[:base_domain] = "ocolocalhost.com#{port_segment}"
    Setting[:signup_domain] = "create.ocolocalhost.com#{port_segment}"

    Setting[:association_enabled] = 'true'
    Setting[:company_enabled] = 'true'
    Setting[:coop_enabled] = 'true'
  end

  def set_up_application_if_necessary
    unless Setting[:base_domain] && Setting[:signup_domain]
      set_up_application
    end
  end
end
World(AppSetup)
