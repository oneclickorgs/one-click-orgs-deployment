require 'faker'

def mock_director
  mock_model(Director, :name => Faker::Name.name)
end
