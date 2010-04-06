module Db::Predicates::LimitedTo
  def self.included(base)
    base.class_eval do
      named_scope :limited_to, lambda { |*num| { :limit => num.flatten.first || 10 } }
    end
  end
end