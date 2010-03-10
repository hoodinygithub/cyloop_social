class Widget::SongBuylinksController < Widget::WidgetController

  def show
    @buylinks = SongBuylink.all(
      :conditinos => {
        :buylink_provider_id => current_site.site_buylink_providers.map(&:id) } )
    respond_to do |format|
      format.xml { render :layout => false }
    end
  end

end