
module Application::Paginator

  def load_page
    @page ||= params[:page].to_i
    if @page == 0
      @page = 1
    end
    @per_page ||= params[:per_page].to_i
    if @per_page < 1 || @per_page > 15
      @per_page = 15
    end
  end

  def paginate( model, options = {} )
    load_page
    model.paginate( {:per_page => @per_page, :page => @page}.merge( options ) )
  end

end