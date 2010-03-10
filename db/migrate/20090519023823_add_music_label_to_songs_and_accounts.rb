class AddMusicLabelToSongsAndAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :music_label, :string
    add_column :songs, :music_label, :string
  end

  def self.down
    remove_column :accounts, :music_label
    remove_column :songs, :music_label
  end
end
