# PartitionedPath is a class that you use for generating the sharded user
# path for, for example, the activity feed.
class PartitionedPath
  def self.path_for(user_id)
    #("%08d" % user_id).scan(/..../)
    ("%03d" % user_id).scan(/./)[0..2].push(user_id.to_s)
  end
  
end