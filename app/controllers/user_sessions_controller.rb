class UserSessionsController < ApplicationController

  #before_filter :require_user, :except => [:new, :create]
  # GET /user_sessions/new
  # GET /user_sessions/new.xml
  def index
		redirect_to new_user_session_path
  end
  
  def new
		@user_session = UserSession.new
		respond_to do |format|
			format.html # new.html.erb
			format.xml { render :xml => @user_session }
		end
  end



  # POST /user_sessions
  # POST /user_sessions.xml
  def create
    @user_session = UserSession.new(params[:user_session])
    respond_to do |format|
      if @user_session.save
				session[:user_id] = current_user.id
				session[:user_role] = current_user.role.role_type
				format.html { redirect_to(dashboard_path, :notice => t("general.login_successful")) }
				format.xml { render :xml => @user_session, :status => :created, :location => @user_session }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @user_session.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /user_sessions/1
  # DELETE /user_sessions/1.xml
  def destroy
    @user_session = UserSession.find
    if @user_session
	    @user_session.destroy
	  end
		reset_session
		flash[:notice] = t("general.logout_successful")
    respond_to do |format|
      format.html { redirect_to "/" }
      format.xml { head :ok }
    end
  end
end
