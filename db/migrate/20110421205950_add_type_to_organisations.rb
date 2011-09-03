class AddTypeToOrganisations < ActiveRecord::Migration
  
  class Organisation < ActiveRecord::Base; end
  
  def self.up
    add_column :organisations, :type, :string
    
    Organisation.update_all(:type => "Association")
  end

  def self.down
    remove_column :organisations, :type
  end
end