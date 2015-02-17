source 'http://rubygems.org'

gem "bundler", "~>1.8.2"

gem "rails", "3.2.21"

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# gem 'sqlite3-ruby', :require => 'sqlite3'
gem "mysql2", "~>0.3.11"

group :assets do
  gem 'sass-rails', '~>3.2.3'
  gem 'coffee-rails', '~>3.2.1'
  gem 'uglifier',     ">= 2.0.1"
  gem 'therubyracer', '~>0.12.1'
end
 
# jQuery is the default JavaScript library in Rails 3.1
gem 'jquery-rails'

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

gem "haml", "~>3.1"
gem "rdiscount", "~>2.1.6"
gem "pdfkit", "~>0.5.2"

gem "daemons", "~>1.0.10"

gem "delayed_job", "~>4.0.0"
gem "delayed_job_active_record", "~>4.0.0"
gem "exception_notification_rails3", "~>1.2.0", :require => 'exception_notifier'

gem "fastercsv", "~>1.5.4", :platforms => :ruby_18

gem 'mail', '~>2.5.4'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
# group :development, :test do
#   gem 'webrat'
# end

group :development do
  gem "capistrano", "~>2.14.2"
  gem "railroad"
  gem "ruby-debug", :platforms => :ruby_18, :require => nil
  gem "ruby-debug19", :platforms => :ruby_19
  gem 'pry'
end

group :development, :test do
  gem "rspec-rails", "~>2.8.1"
  gem "webrat"
  gem "machinist", "~>1.0.6"
  gem "faker", '~>0.3.1'
  gem "rcov", :platforms => :ruby_18
  gem "simplecov", :platforms => :ruby_19
  gem "cucumber-rails", "~>1.4.0", :require => nil
  gem "capybara", "~>1.1.2"
  gem "database_cleaner"
  gem "launchy"
  gem "selenium-webdriver"
end
