class AddFollowingsIndexOptimizations < ActiveRecord::Migration
  def self.up
    add_index :followings, [:followee_id, :approved_at, :updated_at, :follower_id], :name => 'index_followings_on_followee_id_for_sorts'
  end

  def self.down
    remove_index :followings, :column => [:followee_id, :approved_at, :updated_at, :follower_id], :name => 'index_followings_on_followee_id_for_sorts'
  end
end
