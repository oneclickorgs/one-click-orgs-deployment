class AddTypeToMeetings < ActiveRecord::Migration
  def change
    add_column :meetings, :type, :string
  end
end