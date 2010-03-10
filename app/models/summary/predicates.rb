module Summary::Predicates
  def self.included(base)
    base.class_eval do
      belongs_to :site
      
      named_scope :ordered_by, lambda { |*order| { :order => order.flatten.first || 'total_listens DESC' } }      
      named_scope :limited_to, lambda { |*num| { :limit => num.flatten.first || 10 } }
    end
  end
end