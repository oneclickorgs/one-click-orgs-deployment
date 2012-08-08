class CreateAdministrators < ActiveRecord::Migration
  def change
    create_table :administrators do |t|
      t.string   "email",               :limit => 50, :null => false
      t.string   "crypted_password",    :limit => 50
      t.string   "salt",                :limit => 50
      t.string   "password_reset_code"

      t.timestamps
    end
  end
end
