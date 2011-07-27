# Converts Active Model's lint tests for Test::Unit into an RSpec shared example group.
# http://library.edgecase.com/Rails/2010/10/30/activemodel-lint-test-for-rspec.html

shared_examples_for "an active model" do
  include ActiveModel::Lint::Tests
  
  ActiveModel::Lint::Tests.public_instance_methods.map(&:to_s).grep(/^test/).each do |method|
    example method.gsub('_', ' ') do
      send method
    end
  end
  
  def model
    subject
  end
end
