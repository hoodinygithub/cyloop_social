
module AssetsHelper  

  def google_analytics_js_include_tag
    protocol = (request.ssl? ? 'https://ssl.' : 'http://www.')
    javascript_include_tag "#{protocol}google-analytics.com/ga.js"
  end

  def main_scripts
    [
      'jquery',
      'jquery.ui',
      'jquery.infiniteCarousel',
      'jcarousel/lib/jquery.jcarousel',
      'jquery.ifixpng',
      'jquery.corners',
      'jquery.autocomplete',
      'jquery.jeditable',
      'jquery.livequery',
      'jquery-ui-i18n.min.js',
      'jquery.form.js',
      'jrails.js',
      'swfobject',
      'facebox',
      'registration',
      'application',
      'followees',
      'colorpicker',
      'customizer',
      'radio',
      'swf_utils',
      'dashboard'
      ]
  end

  def main_javascript_include_tags
    javascript_include_tag *( main_scripts + [{:cache => 'cyloop3'}] )
  end

  def main_stylesheets
    [
      'theme/ui.core',
      'theme/ui.accordion',
      'theme/ui.datepicker',
      'theme/ui.dialog',
      'theme/ui.progressbar',
      'theme/ui.resizable',
      'theme/ui.slider',
      'theme/ui.tabs',
      'theme/ui.theme',
      'reset',
      'application',
      'jquery.infiniteCarousel',
      'charts',
      'pages',
      'player',
      'registration',      
      'jquery.autocomplete',
      'jcarousel/jquery.jcarousel',
      'jcarousel/skins/tango/skin',
      'facebox',
      'colorpicker',
      'profiles'
      ]
  end

  def main_stylesheets_link_tag
    stylesheet_link_tag *(main_stylesheets + [{:cache => 'cyloop3'}])
  end

end