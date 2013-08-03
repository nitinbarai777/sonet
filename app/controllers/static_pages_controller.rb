class StaticPagesController < ApplicationController
  before_action :set_static_page, only: [:show, :edit, :update, :destroy]
  helper_method :sort_column, :sort_direction
  before_action :require_admin
  before_action :set_header_menu_active
  # GET /static_pages
  # GET /static_pages.json
  def index
    @o_all = get_records(params[:search], params[:page])
  end

  # GET /static_pages/1
  # GET /static_pages/1.json
  def show
  end

  # GET /static_pages/new
  def new
    @o_single = StaticPage.new
  end

  # GET /static_pages/1/edit
  def edit
  end

  # POST /static_pages
  # POST /static_pages.json
  def create
    @o_single = StaticPage.new(static_page_params)

    respond_to do |format|
      if @o_single.save
        format.html { redirect_to static_pages_url, notice: t("general.successfully_created") }
        format.json { render action: 'show', status: :created, location: @o_single }
      else
        format.html { render action: 'new' }
        format.json { render json: @o_single.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /static_pages/1
  # PATCH/PUT /static_pages/1.json
  def update
    respond_to do |format|
      if @o_single.update(static_page_params)
        format.html { redirect_to (is_admin? ? static_pages_url : root_url), notice: t("general.successfully_updated") }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @o_single.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /static_pages/1
  # DELETE /static_pages/1.json
  def destroy
    @o_single.destroy
    respond_to do |format|
      format.html { redirect_to static_pages_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_static_page
      @o_single = StaticPage.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def static_page_params
      params.require(:static_page).permit(:name, :page_route, :content, :is_footer)
    end
    
	  def get_records(search, page)
			static_page_query = StaticPage.search(search)
	  	static_page_query.order(sort_column + " " + sort_direction).paginate(:per_page => 10, :page => page)
	  end    
    
	  def set_header_menu_active
	    @static_pages = true
	  end
	  
	  def sort_column
	    StaticPage.column_names.include?(params[:sort]) ? params[:sort] : "id"
	  end
	
	  def sort_direction
	    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
	  end	      
end
