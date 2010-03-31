class Station < ActiveRecord::Base
  named_scope :available, :conditions => { :available => true }
  belongs_to :playable, :polymorphic => true

  delegate :name, :deleted_at, :to => :playable
end
