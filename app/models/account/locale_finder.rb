module Account::LocaleFinder
  def self.included(base)
    base.class_eval do
      before_validation :fetch_default_entry_point_for_user
      before_validation :fetch_default_locale_for_user
    end
  end

  protected
    def fetch_default_entry_point_for_user
      self.entry_point ||= current_site
    end

    def fetch_default_locale_for_user
      self.locale = entry_point.default_locale if entry_point && locale.nil?
    end
end
