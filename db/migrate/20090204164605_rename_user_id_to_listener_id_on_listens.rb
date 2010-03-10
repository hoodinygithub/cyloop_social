class RenameUserIdToListenerIdOnListens < ActiveRecord::Migration
  def self.up
    rename_column :listens, :user_id, :listener_id
  end

  def self.down
    rename_column :listens, :listener_id, :user_id
  end
end
