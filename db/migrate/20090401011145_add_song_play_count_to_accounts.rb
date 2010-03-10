class AddSongPlayCountToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :song_play_count, :integer, :default => 0
  end

  def self.down
    remove_column :accounts, :song_play_count
  end
end
