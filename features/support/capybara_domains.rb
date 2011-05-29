# Stick to one port for running the app server when using the selenium driver.
# Otherwise (in capybara-0.4 and up) a random, different port is chosen when
# app server is restarted, and this messes with our fixed host+port stored in
# Settings[:base_domain] and Settings[:signup_domain].
Capybara.server_port = 9887

# Monkey-patch for Capybara's rack-test driver, which forces a new rack-test session
# to be started when we switch subdomains. Otherwise, rack-test doesn't feed the
# new hostname from the HTTP request into the app -- instead it keeps passing the previous
# hostname.
# 
# Based on:
# http://stackoverflow.com/questions/4217927/rails-capybara-and-subdomains-how-to-visit-certain-subdomain
class Capybara::Driver::RackTest
  def initialize(app)
    raise ArgumentError, "rack-test requires a rack application, but none was given" unless app
    @app = app
    @default_host = Capybara.default_host
  end
  
  def process(method, path, attributes = {})
    reset_if_host_has_changed
    path = ["http://", @default_host, path].join
    return if path.gsub(/^#{request_path}/, '') =~ /^#/
    path = request_path + path if path =~ /^\?/
    send(method, to_binary(path), to_binary( attributes ), env)
    follow_redirects!
  end

private

  def reset_if_host_has_changed
    if @default_host != Capybara.default_host
      reset! # clears the existing MockSession
      @default_host = Capybara.default_host
    end
  end
end
