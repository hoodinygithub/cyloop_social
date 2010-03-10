class CreateAlbums < ActiveRecord::Migration
  def self.up
    create_table :albums do |t|
      t.string :name
      t.references :owner
      t.integer :songs_count
      t.integer :year
      t.string :label
      t.string :upc
      t.string :avatar_file_name
      t.string :avatar_content_type
      t.integer :avatar_file_size
      t.datetime :avatar_updated_at

      t.timestamps
    end
    add_column :songs, :album_id, :integer
    add_column :songs, :position, :integer
  end

  def self.down
    remove_column :songs, :position
    remove_column :songs, :album_id
    drop_table :albums
  end
end
