class UrlContentsController < ApplicationController
  require 'json'
  before_action :set_url_content, only: [:show, :edit, :update, :destroy]
  helper_method :sort_column, :sort_direction
  before_action :require_user
  before_action :set_header_menu_active
  # GET /url_contents
  # GET /url_contents.json
  def index
    
    session[:url_id] = params[:id] if params[:id]
    unless session[:url_id]
      redirect_to user_urls_url
    end
    @o_all_facebook = get_records(params[:search], params[:page], 'facebook')
    @o_all_twitter = get_records(params[:search], params[:page], 'twitter')
    @o_all_google = get_records(params[:search], params[:page], 'google')
  end

  # GET /url_contents/1
  # GET /url_contents/1.json
  def show
  end

  # GET /url_contents/new
  def new
    @o_single = UrlContent.new
  end

  # GET /url_contents/1/edit
  def edit
  end

  # POST /url_contents
  # POST /url_contents.json
  def create
    @user_url = UserUrl.find(session[:url_id])
    @o_single = UrlContent.new(url_content_params)

    unless params[:url_content][:content].blank?
      facebook_post_id = ''
      if current_user.is_facebook_user?
        me = FbGraph::User.me(session[:token])
        myfeed = me.feed!(
          :message => params[:url_content][:content],
          :picture => "#{BASE_URL}/#{@user_url.image}",
          :link => @user_url.url_name,
          :name => @user_url.title,
          :description => @user_url.desc
        )
        
        input_string = "'"+myfeed.inspect.to_s+"'"
        str1_markerstring = '"id"=>"'
        str2_markerstring = '", :access_token'
        
        facebook_post_id = input_string[/#{str1_markerstring}(.*?)#{str2_markerstring}/m, 1]
        
        notice = t("general.successfully_shared_on_facebook")
      end
      
      if current_user.is_twitter_user?
        Twitter.configure do |config|
          config.consumer_key = TWITTER_CONSUMER_KEY
          config.consumer_secret = TWITTER_CONSUMER_SECRET
          config.oauth_token = session[:token]
          config.oauth_token_secret = session[:secret]
        end
        Twitter.update(params[:url_content][:content])
        notice = t("general.successfully_tweet_on_twitter")
      end
    else
      notice = t("general.content_can_not_be_null")
    end

    respond_to do |format|
      if @o_single.save
        if facebook_post_id
         @o_single.facebook_post_id = facebook_post_id
         @o_single.save  
        end
        format.html { redirect_to url_contents_url, notice: notice}
        format.json { render action: 'show', status: :created, location: @o_single }
      else
        format.html { redirect_to url_contents_url, notice: notice}
        format.json { render json: @o_single.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /url_contents/1
  # PATCH/PUT /url_contents/1.json
  def update
    respond_to do |format|
      if @o_single.update(url_content_params)
        format.html { redirect_to (is_admin? ? url_contents_url : root_url), notice: t("general.successfully_updated") }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @o_single.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /url_contents/1
  # DELETE /url_contents/1.json
  def destroy
    @o_single.destroy
    respond_to do |format|
      format.html { redirect_to url_contents_url }
      format.json { head :no_content }
    end
  end
  
  def add_post_id
    UrlContent.create(:facebook_post_id => params[:post_id], :user_url_id => session[:url_id], :is_facebook_shared => true, :content => params[:content])
    render json: true
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_url_content
      @o_single = UrlContent.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def url_content_params
      params.require(:url_content).permit(:content, :user_url_id, :is_facebook_shared, :is_twitter_shared, :is_google_shared, :facebook_post_id, :facebook_likes_count)
    end
    
    def get_records(search, page, provider)
      @o_single = UrlContent.new
      @user_url = UserUrl.find(session[:url_id])
      if provider == 'facebook'
        url_content_query = @user_url.url_contents.where(:is_facebook_shared => true)
      elsif provider == 'twitter'
        url_content_query = @user_url.url_contents.where(:is_twitter_shared => true)
      else
        url_content_query = @user_url.url_contents.where(:is_google_shared => true)
      end  
      url_content_query.order(sort_column + " " + sort_direction).paginate(:per_page => 5, :page => page)
    end    
    
    def set_header_menu_active
      @url_contents = true
    end
    
    def sort_column
      UrlContent.column_names.include?(params[:sort]) ? params[:sort] : "id"
    end
  
    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end       
end
