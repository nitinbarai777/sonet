class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user, :is_admin?, :is_user?, :is_provider_user?
	SUPER_ADMIN = "SuperAdmin"
	USER = "User"

  private

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
		@current_user = current_user_session && current_user_session.record
  end

  def require_user
    unless current_user
      redirect_to :controller => "fronts", :action => "subscribe"
    end
  end
  
  def require_admin
    unless session[:user_role] == SUPER_ADMIN
      redirect_to :controller => "user_sessions", :action => "new"
    end
  end  
 
  def authenticate_email(email)
    user_exists = User.exists?(email: email)
    if user_exists
			user = User.find_by_email(email)
			return user
	  end
	  return false
  end
  
  def authenticate_change_password(password)
      user_exists = User.exists?(password: password)
      if user_exists
		user = User.find_by_password(password)
		return user
	  end
	  return false
  end

	def is_admin?
		session[:user_role] == SUPER_ADMIN
	end
	
  def is_user?
	 session[:user_role] == USER
  end
  
  def is_provider_user?
    current_user.authorizations
  end
  
  def invite_email_exists?(email)
    user = User.find_by_email(email)
    if user
			user_invited_by_current_user = current_user.invitings.where(:invited_user_id => user.id).first
			if user_invited_by_current_user
				return {result: true, invited_date: user_invited_by_current_user.created_at.to_s(:default_date), is_user: true, user: user, invite: user_invited_by_current_user}
			else
				return {result: false, is_user: true, user: user}
			end	
	  end
	  return {result: false, is_user: false}
  end
  
  def get_host_name(email)
  	unless email.nil?
  		email_arr = []
  		email_arr = email.split("@")
  		if email_arr[1]
  			email_arr = email_arr[1].split(".")
  			email_arr[0]
  		end
  	end
  end
  
end