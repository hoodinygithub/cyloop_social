module Application::Sites

  CURRENT_SITE = Site.find_by_name(ENV['SITE']) ||
                 Site.find_by_name('Cyloop') ||
                 Site.first || 
                 Site.find_or_create_by_name_and_default_locale_and_code("Cyloop", :en, "cyloop")

  def self.included(base)
    base.class_eval do
      before_filter :set_locale

      def set_locale
        I18n.locale = I18n.default_locale = CURRENT_SITE.default_locale || :en
      end

      def self.current_site
        CURRENT_SITE
      end
      
      def self.site_code
        CURRENT_SITE.code
      end
      
      def self.login_type
        CURRENT_SITE.login_type.name rescue "cyloop"
      end
    end
  end
  
end


