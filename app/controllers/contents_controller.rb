class ContentsController < ApplicationController
  before_action :set_content, only: [:show, :edit, :update, :destroy]
  helper_method :sort_column, :sort_direction
  before_action :require_user
  before_action :set_header_menu_active
  # GET /contents
  # GET /contents.json
  def index
    session[:category] = params[:category] if params[:category]
    @o_all = get_records(params[:content], params[:page])
    @search_fields = ['subject']
  end

  def show_content_search
    @o_single = Content.new
  end

  # GET /contents/1
  # GET /contents/1.json
  def show
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

  # GET /contents/new
  def new
    @o_single = Content.new
  end

  # GET /contents/1/edit
  def edit
  end

  # POST /contents
  # POST /contents.json
  def create
    @o_single = Content.new(content_params)

    respond_to do |format|
      if @o_single.save
        format.html { redirect_to contents_url, notice: t("general.successfully_created") }
        format.json { render action: 'show', status: :created, location: @o_single }
      else
        format.html { render action: 'new' }
        format.json { render json: @o_single.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contents/1
  # PATCH/PUT /contents/1.json
  def update
    respond_to do |format|
      if @o_single.update(content_params)
        format.html { redirect_to contents_url, notice: t("general.successfully_updated") }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @o_single.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contents/1
  # DELETE /contents/1.json
  def destroy
    @o_single.destroy
    respond_to do |format|
      format.html { redirect_to contents_url, notice: t("general.successfully_destroyed") }
      format.json { head :no_content }
    end
  end

  private
  
    # Use callbacks to share common setup or constraints between actions.
    def set_content
      @o_single = Content.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def content_params
      params.require(:content).permit!
    end
    
    #fetch search records
    def get_records(search, page)
      if session[:category]
        @category = Category.find(session[:category])
        content_query = @category.contents
      else
        content_query = current_user.contents
      end  
       
      content_query.order(sort_column + " " + sort_direction).paginate(:per_page => 10, :page => page)
    end    
    
    #set header menu active
    def set_header_menu_active
      @content_active = "active"
    end
    
    #column sort
    def sort_column
      Content.column_names.include?(params[:sort]) ? params[:sort] : "id"
    end
  
    #column sort
    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end  
end
