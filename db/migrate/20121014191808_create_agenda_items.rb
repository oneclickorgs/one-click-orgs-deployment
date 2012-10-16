class CreateAgendaItems < ActiveRecord::Migration
  def change
    create_table :agenda_items do |t|
      t.integer :meeting_id
      t.integer :position
      t.string :title
      t.text :minutes

      t.timestamps
    end
  end
end
