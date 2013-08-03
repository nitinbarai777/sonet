class ChangeFeedbackDateToInvites < ActiveRecord::Migration
  def change
  	change_column :invites, :feedback_date, :datetime
  end
end
