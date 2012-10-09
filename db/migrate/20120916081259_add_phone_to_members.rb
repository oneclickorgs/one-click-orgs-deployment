class AddPhoneToMembers < ActiveRecord::Migration
  def change
    add_column :members, :phone, :string
  end
end
