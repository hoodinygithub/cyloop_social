class AddMusicLabelToAlbums < ActiveRecord::Migration
  def self.up
    add_column :albums, :music_label, :string
  end

  def self.down
    remove_column :albums, :music_label
  end
end
