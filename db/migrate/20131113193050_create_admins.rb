class CreateAdmins < ActiveRecord::Migration
  def up
    create_table :admins do |t|
      t.string   :username
      t.string   :password
      t.timestamps
    end
  end
 
  def down
    drop_table :admins
  end
end
