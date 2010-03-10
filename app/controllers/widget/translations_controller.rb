
class Widget::TranslationsController < Widget::WidgetController

  def index
    respond_to do |format|
      format.xml
    end
  end

end