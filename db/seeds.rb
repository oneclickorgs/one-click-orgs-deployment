# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

require 'rticles'

unless Rticles::Document.exists?(:title => 'coop_constitution')
  File.open(File.join(Rails.root, 'data', 'rticles', 'ips', 'ips.yml'), 'r') do |coop_constitution_file|
    coop_constitution_document = Rticles::Document.from_yaml(coop_constitution_file)
    raise "Could not create coop constitution document" unless coop_constitution_document.persisted?
    coop_constitution_document.update_attribute(:title, "coop_constitution")
    Setting[:coop_constitution_document_id] = coop_constitution_document.id
  end
end
