class AddIsReadToInvites < ActiveRecord::Migration
  def change
    add_column :invites, :is_read, :boolean, :default => false
    add_column :invites, :is_original, :boolean, :default => false
  end
end
