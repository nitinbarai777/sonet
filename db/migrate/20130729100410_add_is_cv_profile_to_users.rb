class AddIsCvProfileToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_inactive_cv, :boolean, :default => false, :before => :created_at
  end
end
