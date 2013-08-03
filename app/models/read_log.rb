class ReadLog < ActiveRecord::Base
	belongs_to :inviting, :class_name => "User", :foreign_key => "inviting_user_id"
	belongs_to :invited, :class_name => "User", :foreign_key => "invited_user_id"
end
