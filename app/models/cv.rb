class Cv < ActiveRecord::Base
	belongs_to :user
	has_many :cv_educations, :dependent => :destroy
	has_many :cv_experiences, :dependent => :destroy
	has_many :cv_languages, :dependent => :destroy
	has_many :cv_skills	, :dependent => :destroy
end
