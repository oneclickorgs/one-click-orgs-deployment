# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

require 'rticles'

if ENV['RESET'] || !Rticles::Document.exists?(:title => 'coop_constitution')

  File.open(File.join(Rails.root, 'data', 'rticles', 'ips', 'ips.yml'), 'r') do |coop_constitution_file|

    coop_constitution_document = Rticles::Document.from_yaml(coop_constitution_file)
    raise "Could not create coop constitution document" unless coop_constitution_document.persisted?
    coop_constitution_document.update_attribute(:title, "coop_constitution")

  end

end

if ENV['RESET'] || !Rticles::Document.exists?(:title => 'coop_constitution_2014')

  File.open(File.join(Rails.root, 'data', 'rticles', 'ips_2014', 'ips_2014.yml'), 'r') do |coop_constitution_file|

    coop_constitution_document = Rticles::Document.from_yaml(coop_constitution_file)
    raise "Could not create 2014 coop constitution document" unless coop_constitution_document.persisted?
    coop_constitution_document.update_attribute(:title, "coop_constitution_2014")
    Setting[:coop_constitution_document_id] = coop_constitution_document.id

  end

end
