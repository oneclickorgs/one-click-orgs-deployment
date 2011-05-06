Given /^the application is set up$/ do
  # Using smackaho.st to give us automatic resolution to localhost
  Setting[:base_domain] = "smackaho.st:#{Capybara.server_port}"
  Setting[:signup_domain] = "create.smackaho.st:#{Capybara.server_port}"
end

When /^the domain is the signup domain$/ do
  When %Q{the domain is "#{Setting[:signup_domain].sub(/:\d+$/, '')}"}
end
