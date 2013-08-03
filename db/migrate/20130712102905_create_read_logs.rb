class CreateReadLogs < ActiveRecord::Migration
  def change
    create_table :read_logs do |t|
			t.integer   :inviting_user_id
			t.integer   :invited_user_id
      t.timestamps
    end
  end
end
