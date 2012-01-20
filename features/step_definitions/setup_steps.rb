Given /^the application is set up$/ do
  # Using smackaho.st to give us automatic resolution to localhost
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
  
  Setting[:base_domain] = "smackaho.st#{port_segment}"
  Setting[:signup_domain] = "create.smackaho.st#{port_segment}"
end

Given /^the application is not set up yet$/ do
  step "the domain is \"www.example.com\""
end

When /^the domain is the signup domain$/ do
  step %Q{the domain is "#{Setting[:signup_domain].sub(/:\d+$/, '')}"}
end
