module Account::FolloweeCache
  def self.included(base)
    base.class_eval do
      serialize :followee_cache, Array
    end
  end

  def update_followee_cache
    self.followee_cache = followee_ids
    self.delete_follower_cache
    save!
  end

  def followee_cache
    read_attribute(:followee_cache) || write_attribute(:followee_cache, [])
  end
end
