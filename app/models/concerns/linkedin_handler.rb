module LinkedinHandler
  extend ActiveSupport::Concern

    def create_cv(picture_url, summary)
    	cv = Cv.create(:user_id => self.id, :picture_filename => picture_url, :summary => summary)
    end
    
    def create_positions(positions)
    	cv = Cv.find_by_user_id(self.id)
			positions.all.each do |row|
				start_end_date = check_date_positions(row)
				cv_attr = [:user_id => self.id, 
															:cv_id => cv.id,
															:from => start_end_date[0],
															:to => start_end_date[1],
															:company_name => row.company.name,
															:job_title => row.title,
															:description => row.summary]
															
				CvExperience.create(cv_attr)
			end      	
    end
    
    def create_skills(skills)
    	cv = Cv.find_by_user_id(self.id)
			skills.all.each do |row|
				cv_attr = [:user_id => self.id, 
															:cv_id => cv.id,
															:name => row.skill.name,
															:sequence => row.id]
															
				CvSkill.create(cv_attr)
			end              	
    end
    
    def create_languages(languages)
    	cv = Cv.find_by_user_id(self.id)
			languages.all.each do |row|
				cv_attr = [:user_id => self.id, 
															:cv_id => cv.id,
															:language => row.language.name,
															:proficiency => (row.proficiency.name unless row.proficiency.nil?)]
															
				CvLanguage.create(cv_attr)
			end      	
    end
    
    def create_educations(educations)
    	cv = Cv.find_by_user_id(self.id)
			educations.all.each do |row|
				cv_attr = [:user_id => self.id, 
															:cv_id => cv.id,
															:school => row.school_name,
															:from_year => row.start_date.year,
															:to_year => row.end_date.year,
															:degree => row.degree,
															:field_of_study => row.field_of_study,
															:grade => row.grade]
															
				CvEducation.create(cv_attr)
			end      	
		end
		
		def personal_details(date_of_birth, headline, phone_numbers)
			birthdate = ''
			if date_of_birth
				if date_of_birth["year"]
					birthdate = "#{date_of_birth["year"]}-#{date_of_birth["month"]}-#{date_of_birth["day"]}"
				else
					birthdate = "#{date_of_birth["month"]}-#{date_of_birth["day"]}"
				end
			end
			self.birthdate = birthdate
			self.headline = headline
			self.mobile = phone_numbers.all.first.phone_number unless phone_numbers.all.nil?
			self.save(:validate => false)				
		end
			
		def check_date_positions(position)
	    if position.start_date.present?
	    	if position.start_date.month.present?
	      	start_date = "#{position.start_date.year}-#{position.start_date.month}-01"
	      else
	      	start_date = "#{position.start_date.year}-01-01"
	      end
	      
	      if position.is_current
	        end_date = Date.today.to_s
	      else
	      	if position.end_date.month.present?
	        	end_date = "#{position.end_date.year}-#{position.end_date.month}-01"
	        else
	        	end_date = "#{position.end_date.year}-01-01"
	        end		
	      end
	      
	      return [start_date, end_date]
	    end
		end
		
		def prepare_xml_data
			cv_hsh = {}
			#personal info
			cv_hsh[:personal_info] = { :first_name => self.first_name,
																 :last_name => self.last_name,
																 :mobile => self.mobile,
																 :phone => self.phone,
																 :birthdate => self.birthdate,
															 }
			cv_hsh[:summary] = self.cv.summary
			cv_hsh[:picture_filename] = self.cv.picture_filename
			
			#experiences
			cv_temp = []
			self.cv_experiences.load.each do |row|
				cv_attr = {:from => row.from,
										:to => row.to,
										:company_name => row.company_name,
										:job_title => row.job_title,
										:description => row.description}
				cv_temp << cv_attr						
			end
			cv_hsh[:experiences] = cv_temp   	
			
			#languages
			cv_temp = []
			self.cv_languages.load.each do |row|
				cv_attr = {:language => row.language,
										:proficiency => row.proficiency}
				cv_temp << cv_attr						
			end
			cv_hsh[:languages] = cv_temp		
			
			#skills
			cv_temp = []
			self.cv_skills.load.each do |row|
				cv_attr = {:name => row.name,
										:sequence => row.sequence}
				cv_temp << cv_attr						
			end
			cv_hsh[:skills] = cv_temp  	
			
			#educations
			cv_temp = []
			self.cv_educations.load.each do |row|
			cv_attr = {:school => row.school,
								:from_year => row.from_year,
								:to_year => row.to_year,
								:degree => row.degree,
								:field_of_study => row.field_of_study,
								:grade => row.grade}
				cv_temp << cv_attr						
			end
			cv_hsh[:educations] = cv_temp
			return cv_hsh					
		end
end