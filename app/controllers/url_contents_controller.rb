class UrlContentsController < ApplicationController
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

    image = '' 
    if @user_url.image
      image = "http://economyofone.herokuapp.com/assets/logo-b8495defaaff575ccd446b3e14cc23e2.png"
    end


    unless params[:url_content][:content].blank?
      if current_user.is_facebook_user?
        me = FbGraph::User.me(current_user.authorizations.first.token)
        me.feed!(
          :message => params[:url_content][:content],
          :picture => image,
          :link => @user_url.url_name,
          :name => @user_url.title,
          :description => @user_url.desc
        )
        notice = t("general.successfully_shared_on_facebook")
      end
      
      if current_user.is_twitter_user?
        Twitter.configure do |config|
          config.consumer_key = TWITTER_CONSUMER_KEY
          config.consumer_secret = TWITTER_CONSUMER_SECRET
          config.oauth_token = current_user.authorizations.first.token
          config.oauth_token_secret = current_user.authorizations.first.secret
        end
        Twitter.update(params[:url_content][:content])
        notice = t("general.successfully_tweet_on_twitter")
      end
    else
      notice = t("general.content_can_not_be_null")
    end

    respond_to do |format|
      if @o_single.save
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_url_content
      @o_single = UrlContent.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def url_content_params
      params.require(:url_content).permit(:content, :user_url_id, :is_facebook_shared, :is_twitter_shared, :is_google_shared)
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
      url_content_query.order(sort_column + " " + sort_direction).paginate(:per_page => 10, :page => page)
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
