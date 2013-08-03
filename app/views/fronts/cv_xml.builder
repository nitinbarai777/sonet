  xml.instruct!
  current_user.cv_experiences.all.each do |experience|
    xml.experience do
      xml.company_name experience.company_name
      xml.job_title experience.job_title
    end
  end