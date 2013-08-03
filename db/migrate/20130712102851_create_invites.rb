class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
			t.integer   :inviting_user_id
			t.integer   :invited_user_id
			t.text    :feedback
			t.string    :tracking_pixel
			t.datetime  :confirmed_at
			
      t.timestamps
    end
  end
end
