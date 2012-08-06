class AddAddressToMembers < ActiveRecord::Migration
  def change
    add_column :members, :address, :text
  end
end
