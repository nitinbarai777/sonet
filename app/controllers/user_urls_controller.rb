class UserUrlsController < ApplicationController
  before_action :set_user_url, only: [:show, :edit, :update, :destroy]
  helper_method :sort_column, :sort_direction
  before_action :require_user
  before_action :set_header_menu_active
  # GET /user_urls
  # GET /user_urls.json
  def index
    @o_all = get_records(params[:search], params[:page])
  end

  # GET /user_urls/1
  # GET /user_urls/1.json
  def show
  end

  # GET /user_urls/new
  def new
    @o_single = UserUrl.new
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
        format.html { redirect_to user_urls_url, notice: notice}
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
        format.html { redirect_to (is_admin? ? user_urls_url : root_url), notice: t("general.successfully_updated") }
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
    
    def get_records(search, page)
      user_url_query = current_user.user_urls.search(search)
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
