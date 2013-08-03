class UserMailer < ActionMailer::Base
  default :from => "'EconomyOfOne' <support@economyofone.com>"

  def registration_confirmation(email, body)
    mail(:to => "#{email}", :subject => t("general.new_registration"), :body => body, :content_type => "text/html")
  end

  def forgot_password_confirmation(email,new_pass, body)
    #attachments["rails.png"] = File.read("#{Rails.root}/public/images/rails.png")
    mail(:to => "#{email}", :subject => t("general.password_reset"), :body => body, :content_type => "text/html")
  end
  
  def invite_user_confirmation(email,subject, user, opts)
		@username = opts[:username]
		@invited_user = opts[:invited_user]
		@contact = opts[:contact]
    attachments["CV_#{user.user_name}.html"] = File.read("#{Rails.public_path}/uploads/cv/CV_#{user.user_name}.html")    
    mail(:to => "#{email}", :subject => subject)
  end
    
end