class AddMeetingPermissionToDirectors < ActiveRecord::Migration
  def self.up
    Company.all.each do |company|
      company.clauses.create!(
        :name => 'permission_director_meeting',
        :started_at => Time.now.utc,
        :boolean_value => true
      )
    end
  end
  
  def self.down
    Clause.where(:name => 'permission_director_meeting').destroy_all
  end
end
