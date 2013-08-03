class CvEducation < ActiveRecord::Base
	belongs_to :user
	belongs_to :cv
end
