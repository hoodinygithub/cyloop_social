# == Schema Information
#
# Table name: blocks
#
#  id         :integer(4)      not null, primary key
#  blocker_id :integer(4)
#  blockee_id :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class Block < ActiveRecord::Base
  belongs_to :blocker, :class_name => 'User'
  belongs_to :blockee, :class_name => 'User'
  validates_presence_of :blocker, :blockee
  validates_uniqueness_of :blockee_id, :scope => :blocker_id, :message => :already_blocked
  after_create :unfollow_blocker
  
  protected 
    def unfollow_blocker
      if following = blockee.followings.find_by_followee_id(blocker_id)
        following.destroy 
      end
    end
    
end
