
ActiveRecord::Base.class_eval do

  def self.default_scope(options = {})
    self.default_scoping << { :find => options, :create => options[:conditions].is_a?(Hash) ? options[:conditions] : {} }
  end

end