class ChangeIndexesOnFollowings < ActiveRecord::Migration
  def self.up
    ActiveRecrord::Base.connection.execute <<-EOF
    ALTER TABLE `followings` 
    ADD follower_name varchar(255),
    ADD followee_name varchar(255),
    DROP KEY `index_followings_on_followee_id_for_sorts`,
    ADD KEY `ix_sort_by_follower_name_for_followee_id` (followee_id, follower_name),
    ADD KEY `ix_sort_by_followee_name_for_follower_id` (follower_id, followee_name),
    ADD KEY `ix_sort_by_updated_for_follower_id` (follower_id, updated_at)    
    EOF
    
    
  end

  def self.down
    ActiveRecrord::Base.connection.execute <<-EOF
    ALTER TABLE `followings` 
    DROP KEY `ix_sort_by_follower_name_for_followee_id`,
    DROP KEY `ix_sort_by_followee_name_for_follower_id`,
    DROP KEY `ix_sort_by_updated_for_follower_id`,
    DROP COLUMN `follower_name`,
    DROP COLUMN `followee_name`,
    ADD KEY `index_followings_on_followee_id_for_sorts` (followee_id, approved_at, updated_at, follower_id)
    EOF
  end
end
