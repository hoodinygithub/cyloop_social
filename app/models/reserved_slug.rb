# == Schema Information
#
# Table name: reserved_slugs
#
#  id         :integer(4)      not null, primary key
#  slug       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class ReservedSlug < ActiveRecord::Base
  validates_presence_of :slug
  validates_uniqueness_of :slug
  
  define_index do
    indexes :slug
    set_property :min_prefix_len => 1
    set_property :enable_star => 1
  end  
  
  module ClassMethods   
    def search(*args)
      super(*args).compact
    end    
  end
end
