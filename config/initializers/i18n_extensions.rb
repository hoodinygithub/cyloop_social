I18n.class_eval do

  def self.with_locale( _locale = nil )
    _locale ||= self.default_locale
    _previous_locale = self.locale
    self.locale = _locale
    begin
      yield
    ensure
      self.locale = _previous_locale
    end
  end

end