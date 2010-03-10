require "digest/sha1"

class WidgetApiKey < ActiveRecord::Base

  before_validation_on_create :set_api_key

  named_scope :available, :conditions => { :available => true }

  def set_api_key
    if self.api_key.blank?
      self.write_attribute( :api_key, self.class.generate )
    end
  end

  class << self

    def generate
      Digest::SHA1.hexdigest(Time.now.to_s + rand(987321654987321664789).to_s)[1..100]
    end

  end

end
