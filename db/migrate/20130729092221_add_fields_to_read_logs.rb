class AddFieldsToReadLogs < ActiveRecord::Migration
  def change
    add_column :read_logs, :ip_add, :string
    add_column :read_logs, :host_name, :string
  end
end
