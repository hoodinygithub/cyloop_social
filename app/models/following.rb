# == Schema Information
#
# Table name: followings
#
#  id          :integer(4)      not null, primary key
#  follower_id :integer(4)
#  followee_id :integer(4)
#  created_at  :datetime
#  updated_at  :datetime
#  songs       :boolean(1)
#  playlists   :boolean(1)
#  stations    :boolean(1)
#  approved_at :datetime
#

class Following < ActiveRecord::Base
  after_create :after_create_callback
  after_destroy :after_destroy_callback

  index [:id, :followee_id, :follower_id, :approved_at]

  belongs_to :follower, :class_name => 'Account'
  belongs_to :followee, :class_name => 'Account'
  validates_presence_of :follower, :followee
  validates_uniqueness_of :followee_id, :scope => :follower_id, :message => 'followings.awaiting_approval'

  validate :check_follower_not_blocked

  named_scope :approved, :conditions => "followings.approved_at IS NOT NULL"
  named_scope :pending, :conditions => {:approved_at => nil, :accounts => {:deleted_at => nil}},  :joins => "INNER JOIN accounts ON accounts.deleted_at IS NULL and accounts.id = followings.follower_id"

  def after_create_callback
    update_followee_cache
    increment_counts if self.approved?
  end


  def after_destroy_callback
    update_followee_cache
    decrement_counts if self.approved?
  end

  def update_followee_cache
    follower.update_followee_cache
    followee.delete_follower_cache
  end

  def increment_counts
    # Account.increment_counter(:follower_count, followee.id)
    # Account.increment_counter(:followee_count, follower.id)
    followee.increment!(:follower_count)
    follower.increment!(:followee_count)
  end

  def decrement_counts
    # Account.decrement_counter(:follower_count, followee.id)
    # Account.decrement_counter(:followee_count, follower.id)
    followee.decrement!(:follower_count)
    follower.decrement!(:followee_count)
  end

  def approved?
    !approved_at.nil?
  end

  def approve!
    unless approved?
      transaction do
        update_attribute(:approved_at, Time.now)
        update_followee_cache
        increment_counts
      end
    end
  end

  before_create do |f|
    unless f.followee.private_profile?
      # Set all three so there's no chance of approved_at occurring first
      f.created_at = f.updated_at = f.approved_at = Time.now.utc
    end
  end


  protected
    def check_follower_not_blocked
      errors.add(:followee, :has_blocked_you) if followee.is_a?(User) && followee.blockees.include?(follower)
    end

end

