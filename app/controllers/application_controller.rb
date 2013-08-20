class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user, :is_admin?, :is_user?, :is_provider_user?
  before_filter :add_xframe
	SUPER_ADMIN = "SuperAdmin"
	USER = "User"

  private

  
  def add_xframe
    headers['X-Frame-Options'] = 'GOFORIT'
  end

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
      redirect_to :controller => "fronts", :action => "login"
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
    current_user.authorization
  end
  
  def get_main_page_feed_url(home_main_url)
    host_name = get_host_from_url(home_main_url)
    @page_url = !host_name.include?('www') ? 'http://www.' + host_name.to_s : 'http://' + host_name.to_s
    @is_www = true
    begin
      res = Net::HTTP.get_response(URI.parse(@page_url))
      body = res.body
      if body.length < 100
        @is_www = false
        host_name = host_name.split('www.').last
        @page_url = 'http://' + host_name.to_s
        res = Net::HTTP.get_response(URI.parse(@page_url))
        body = res.body
        if body.length < 100
          body = ''
        end
      end
      content = ''
      begin
          cleaned = body.dup.force_encoding('UTF-8')
          unless cleaned.valid_encoding?
             cleaned = body.encode( 'UTF-8', 'windows-874' )
          end
          content = cleaned
          content = content.gsub("href", "hreff")
          
          head_part = content.scan(/<head>([^<>]*)<\/head>/imu).flatten
          content = content.gsub(head_part, " ") 
          
      rescue
      end
      
      
      #write javascript file start
      
      directory_file = Rails.public_path.to_s + "/iframe.html"
      
      target = File.open(directory_file, 'w') {|f| f.write(content) }
      
      return content
    rescue
    end
  end  
  
  def get_host_from_url(url)
    uri = URI.parse(url)
    uri = URI.parse("http://#{url}") if uri.scheme.nil?
    host = uri.host.downcase.to_s + uri.path.to_s + uri.query.to_s + uri.fragment.to_s
    return host
  end    
  
end