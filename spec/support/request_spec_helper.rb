module RequestSpecHelper
  # Using RSpec 3 and Capybara 2, Capybara is no longer supported in request specs.
  # This convenience method allows us to carry on using Capybara matchers against
  # the responses produced during request specs.
  #
  # https://relishapp.com/rspec/rspec-rails/v/3-1/docs/request-specs/request-spec
  # http://robots.thoughtbot.com/use-capybara-on-any-html-fragment-or-page
  def page
    Capybara::Node::Simple.new(response.body)
  end
end
