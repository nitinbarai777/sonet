class CvExperience < ActiveRecord::Base
	belongs_to :user
	belongs_to :cv	
end
