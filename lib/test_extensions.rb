Account.class_eval do
  def city_name=(name)
    unless name.blank?
      self.city = City.search(name).first || City.first( :conditions => [ 'name LIKE ?', "#{name}%" ] )
    else
      self.city = nil
    end
  end
end

ReservedSlug.class_eval do
  def self.search(*args)
    find_all_by_slug(args)
  end
end

Album.class_eval do
  def self.search(*args)
    find_all_by_name(args)
  end
end

Song.class_eval do
  def self.search(*args)
    find_all_by_title(args)
  end
end

City.class_eval do
  def self.search(*args)
    city = args[0].gsub('*','')
    find_all_by_name(city)
  end
end
