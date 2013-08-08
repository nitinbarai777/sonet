class UserUrlsController < ApplicationController
  before_action :set_user_url, only: [:show, :edit, :update, :destroy]
  helper_method :sort_column, :sort_direction
  before_action :require_user
  before_action :set_header_menu_active
  # GET /user_urls
  # GET /user_urls.json
  def index
    @o_all = get_records(params[:search], params[:page], params[:user_id])
  end

  # GET /user_urls/1
  # GET /user_urls/1.json
  def show
  end

  # GET /user_urls/new
  def new
    @o_single = UserUrl.new
  end
  
  def share_content
    @o_single = UserUrl.new
    @o_url_content = UrlContent.new
    @contact_body = ''
    if request.post?
      session[:user_url] = params[:user_url][:url_name] if params[:user_url][:url_name]
      unless session[:user_url].blank?
        @contact_body = get_main_page_feed_url(session[:user_url])
      else
        flash[:notice] = t("general.url_is_required")
        render action: 'share_content'
      end
    else
      unless session[:user_url].blank?
        @contact_body = get_main_page_feed_url(session[:user_url])
      end        
    end
  end  
  
  def send_content
      facebook_post_id = ''
      if current_user.is_facebook_user?
        me = FbGraph::User.me(session[:token])
        myfeed = me.feed!(
          :message => params[:url_content][:content],
          :picture => "",
          :link => session[:user_url],
          :name => "",
          :description => ""
        )
        
        input_string = "'"+myfeed.inspect.to_s+"'"
        str1_markerstring = '"id"=>"'
        str2_markerstring = '", :access_token'
        
        facebook_post_id = input_string[/#{str1_markerstring}(.*?)#{str2_markerstring}/m, 1]
        
        flash[:notice] = t("general.successfully_shared_on_facebook")
      end
      
      if current_user.is_twitter_user?
        Twitter.configure do |config|
          config.consumer_key = TWITTER_CONSUMER_KEY
          config.consumer_secret = TWITTER_CONSUMER_SECRET
          config.oauth_token = session[:token]
          config.oauth_token_secret = session[:secret]
        end
        Twitter.update(params[:url_content][:content])
        flash[:notice] = t("general.successfully_tweet_on_twitter")
      end
      redirect_to share_content_url
  end

  # GET /user_urls/1/edit
  def edit
  end

  # POST /user_urls
  # POST /user_urls.json
  def create
    @o_single = UserUrl.new(user_url_params)
    respond_to do |format|
      if @o_single.save
        format.html { redirect_to user_urls_url, notice: t("general.successfully_created")}
        format.json { render action: 'show', status: :created, location: @o_single }
      else
        format.html { render action: 'new' }
        format.json { render json: @o_single.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user_urls/1
  # PATCH/PUT /user_urls/1.json
  def update
    respond_to do |format|
      if @o_single.update(user_url_params)
        format.html { redirect_to user_urls_url, notice: t("general.successfully_updated") }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @o_single.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_urls/1
  # DELETE /user_urls/1.json
  def destroy
    @o_single.destroy
    respond_to do |format|
      format.html { redirect_to user_urls_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_url
      @o_single = UserUrl.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_url_params
      params.require(:user_url).permit(:url_name, :image, :user_id, :title, :desc)
    end
    
    def get_records(search, page, user_id)
      if is_admin?
        session[:url_user_id] = user_id unless user_id.blank?
        if session[:url_user_id]
          user = User.find(session[:url_user_id])
        else
          user = current_user
        end  
      else
        user = current_user
      end 
      user_url_query = user.user_urls.search(search)
      user_url_query.order(sort_column + " " + sort_direction).paginate(:per_page => 10, :page => page)
    end    
    
    def set_header_menu_active
      @user_urls = true
    end
    
    def sort_column
      UserUrl.column_names.include?(params[:sort]) ? params[:sort] : "id"
    end
  
    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end       
end
