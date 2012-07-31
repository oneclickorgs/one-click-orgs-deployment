# Stick to one port for running the app server when using the selenium driver.
# Otherwise (in capybara-0.4 and up) a random, different port is chosen when
# app server is restarted, and this messes with our fixed host+port stored in
# Settings[:base_domain] and Settings[:signup_domain].
Capybara.server_port = 9887 + ENV['TEST_ENV_NUMBER'].to_i
