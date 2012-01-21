source 'http://rubygems.org'

gem "bundler", "~>1.0.0"

gem "rails", "3.0.10"

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# gem 'sqlite3-ruby', :require => 'sqlite3'
gem "mysql"

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

gem "haml", "~>3.0.18"
gem "rdiscount"
gem "pdfkit"

gem "daemons", "~>1.0.10"

gem "delayed_job", "2.1.4"

gem "exception_notification_rails3", :require => 'exception_notifier'

gem "fastercsv", :platforms => :ruby_18

gem 'mail', '~>2.2.19'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
# group :development, :test do
#   gem 'webrat'
# end

group :development do
  gem "capistrano", "~>2.5.19"
  gem "railroad"
  gem "ruby-debug", :platforms => :ruby_18, :require => nil
  gem "ruby-debug19", :platforms => :ruby_19
end

group :development, :test do
  gem "rspec-rails", "~>2.8.1"
  gem "webrat", "~>0.7.1"
  gem "machinist", "~>1.0.6"
  gem "faker", '~>0.3.1'
  gem "rcov", "~>0.9.8"
  gem "cucumber-rails", "~>0.4.1"
  gem "capybara", "~>0.4.1.2"
  gem "database_cleaner", "~>0.6.7"
  gem "launchy", "~>0.4.0"
  gem "selenium-webdriver", "~>2.12.2"
end
