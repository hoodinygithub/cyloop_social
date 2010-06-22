module Searchable::ByNameAndSlug
  module ClassMethods    
    if RAILS_ENV =~ /test/ # bad bad bad
      def search(*args)
        options = args.extract_options!
        starts_with(args[0]).paginate :page => (options[:page] || 1)
      end
    else
      def search(*args)
        args[0] = "#{args[0]}*"
        super(*args).compact
      end
    end
  end
  
  def self.included(base)
    base.class_eval do
      named_scope :starts_with, lambda { |prefix| { :conditions => ["name LIKE ?", "#{prefix}%"] } }

      define_index do
        where "deleted_at IS NULL AND network_id = 1"
        indexes :name, :sortable => true
        indexes :slug
        set_property :min_prefix_len => 1
        set_property :enable_star => 1
        set_property :allow_star => 1
        has :created_at
      end
    end
    base.extend ClassMethods
  end
end