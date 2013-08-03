class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :crypted_password, :null => true
      t.string :password_salt, :null => true
      t.string :persistence_token, :null => true
	    t.string :image
	    t.string :register_token
      t.boolean :is_active, :default => true
      t.boolean :is_provider, :default => true
			t.integer   :login_count,         :null => false, :default => 0 # optional, see Authlogic::Session::MagicColumns
			t.integer   :failed_login_count,  :null => false, :default => 0 # optional, see Authlogic::Session::MagicColumns
			t.datetime  :last_request_at                                    # optional, see Authlogic::Session::MagicColumns
			t.datetime  :current_login_at                                   # optional, see Authlogic::Session::MagicColumns
			t.datetime  :last_login_at                                      # optional, see Authlogic::Session::MagicColumns
			t.string    :current_login_ip                                   # optional, see Authlogic::Session::MagicColumns
			t.string    :last_login_ip                                      # optional, see Authlogic::Session::MagicColumns

      t.timestamps
    end
  end
end
