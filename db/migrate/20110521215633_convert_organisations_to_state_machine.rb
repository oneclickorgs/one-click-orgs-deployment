class ConvertOrganisationsToStateMachine < ActiveRecord::Migration
  class Organisation < ActiveRecord::Base;end
  class Clause < ActiveRecord::Base; end
  
  def self.up
    add_column :organisations, :state, :string
    
    Organisation.all.each do |organisation|
      state_clause = Clause.where(
        :organisation_id => organisation.id,
        :name => 'organisation_state',
        :ended_at => nil
      ).order('started_at DESC').first
      
      if state_clause
        organisation.state = state_clause.text_value
      else
        organisation.state = 'pending'
      end
      
      organisation.save!
    end
  end

  def self.down
    Organisation.all.each do |organisation|
      state_clause = Clause.where(
        :organisation_id => organisation.id,
        :name => 'organisation_state',
        :ended_at => nil
      ).order('started_at DESC').first
      
      if state_clause
        if state_clause.text_value != organisation.state
          state_clause.update_attribute(:ended_at, Time.now.utc)
          Clause.create!(
            :organisation_id => organisation.id,
            :name => 'organisation_state',
            :started_at => Time.now.utc,
            :text_value => organisation.state
          )
        end
      else
        Clause.create!(
          :organisation_id => organisation.id,
          :name => 'organisation_state',
          :started_at => Time.now.utc,
          :text_value => organisation.state
        )
      end
    end
    
    remove_column :organisations, :state
  end
end
