class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  helper_method :sort_column, :sort_direction
  before_action :require_admin
  before_action :set_header_menu_active
  # GET /users
  # GET /users.json
  def index
    @o_all = get_records(params[:search], params[:page])
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @o_single = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @o_single = User.new(user_params)

    respond_to do |format|
      if @o_single.save
				@o_single.role = Role.find(params[:role_id])
			  body = render_to_string(:partial => "common/registration_mail", :locals => { :username => @o_single.username, :password => params[:password] }, :formats => [:html])
			  body = body.html_safe
			  UserMailer.registration_confirmation(@o_single.email, body).deliver      	
        format.html { redirect_to users_url, notice: t("general.successfully_created") }
        format.json { render action: 'show', status: :created, location: @o_single }
      else
        format.html { render action: 'new' }
        format.json { render json: @o_single.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @o_single.update_attributes(user_params)
      	role = Role.find(params[:role_id])
      	@o_single.role = Role.find(params[:role_id])
        format.html { redirect_to (is_admin? ? users_url : root_url), notice: t("general.successfully_updated") }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @o_single.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @o_single.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @o_single = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :is_active, :username, :contact, :password, :password_confirmation)
    end
    
	  def get_records(search, page)
			user_query = User.where(:is_provider => true)
	  	user_query.order(sort_column + " " + sort_direction).paginate(:per_page => 10, :page => page)
	  end    
    
	  def set_header_menu_active
	    @users = true
	  end
	  
	  def sort_column
	    User.column_names.include?(params[:sort]) ? params[:sort] : "id"
	  end
	
	  def sort_direction
	    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
	  end	      
end
