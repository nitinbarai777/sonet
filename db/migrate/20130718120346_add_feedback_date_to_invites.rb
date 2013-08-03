class AddFeedbackDateToInvites < ActiveRecord::Migration
  def change
    add_column :invites, :feedback_date, :date
  end
end
