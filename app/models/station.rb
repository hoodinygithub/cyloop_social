# == Schema Information
#
# Table name: stations
#
#  id            :integer(4)      not null, primary key
#  available     :boolean(1)      default(TRUE), not null
#  playable_type :string(25)
#  playable_id   :integer(4)
#  created_at    :datetime
#  updated_at    :datetime
#

class Station < ActiveRecord::Base
  named_scope :available, :conditions => { :available => true }
  belongs_to :playable, :polymorphic => true

  delegate :name, :deleted_at, :to => :playable
end
