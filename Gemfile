source 'http://rubygems.org'

gem "bundler", ">=1.0.0"

gem "rails", "3.2.3"

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

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', '~> 3.2.3'
  gem 'uglifier', '>= 1.0.3'
  gem 'therubyracer'
end

gem "jquery-rails", "~>2.0.2"
gem "haml", "~>3.1.4"
gem "rdiscount"
gem "pdfkit"
gem "delayed_job", "~>3.0.1"
gem "delayed_job_active_record"
gem "exception_notification_rails3", :require => 'exception_notifier'
gem "cancan", "~>1.6.4"
gem "state_machine", "~>1.1.2"
gem "fastercsv", :platforms => :ruby_18

gem 'mail', '>=2.2.19'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
# group :development, :test do
#   gem 'webrat'
# end

group :development do
  gem "capistrano", "~>2.11.2"
  gem "railroad"
  gem "ruby-debug", :platforms => :ruby_18, :require => nil
  gem "ruby-debug19", :platforms => :ruby_19
  gem 'pry'
end

group :development, :test do
  gem "rspec-rails", "~>2.9.0"
  gem "webrat", "~>0.7.1"
  gem "machinist", :git => "git://github.com/chrismear/machinist.git", :branch => "make_on_has_many"
  gem "faker", '~>1.0.1'
  gem "rcov", :platforms => :ruby_18
  gem "simplecov", :platforms => :ruby_19
  gem "cucumber-rails", "~>1.3.0", :require => nil
  gem "capybara", "~>1.1.1"
  gem "database_cleaner", "~>0.7.1"
  gem "launchy"
  gem "selenium-webdriver", "~>2.20.0"
end
