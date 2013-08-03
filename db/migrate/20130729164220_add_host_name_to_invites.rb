class AddHostNameToInvites < ActiveRecord::Migration
  def change
    add_column :invites, :host_name, :string
  end
end
