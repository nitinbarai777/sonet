class CreateUserRoles < ActiveRecord::Migration
  def change
    create_table :user_roles do |t|
    	t.references :role
			t.references :user
      t.timestamps
    end
  end
end
