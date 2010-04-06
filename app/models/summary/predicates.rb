module Summary::Predicates
  def self.included(base)
    base.class_eval do
      belongs_to :site
      
      named_scope :ordered_by, lambda { |*order| { :order => order.flatten.first || 'total_listens DESC' } }      
    end
  end
end
