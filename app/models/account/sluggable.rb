module Account::Sluggable

  def self.included(base)
    base.class_eval do
      validates_presence_of :slug
      validates_uniqueness_of :slug, :scope => :deleted_at, :case_sensitive => false
      validates_format_of :slug,
        :with => /\A[^_-]/,
        :allow_blank => true,
        :message => :cannot_start_with_punctuation
      validates_format_of :slug,
        :with => /[^_-]\z/,
        :allow_blank => true,
        :message => :cannot_end_with_punctuation
      validates_format_of :slug,
        :with => /\A[A-Za-z0-9_-]+\z/,
        :allow_blank => true,
        :message => :can_only_contain_letters_numbers_and_hyphens
      validate_on_create :verifiy_reserved_slugs
    end
  end  

  def to_param
    slug
  end

  def slug=( new_value )
    unless new_value.blank?
      self.write_attribute( :slug, new_value.downcase )
    end
  end

  def email=( new_value )
    unless new_value.blank?
      self.write_attribute( :email, new_value.downcase )
    end
  end

  protected
  
  def verifiy_reserved_slugs
    found_items = ReservedSlug.all( :conditions => { :slug =>self.slug  } )
    found_items += AccountSlug.all( :conditions => { :slug => self.slug } )
    if found_items.size > 0
      self.errors.add(:slug, I18n.t("activerecord.errors.messages.exclusion"))
    end
  end
  
end
