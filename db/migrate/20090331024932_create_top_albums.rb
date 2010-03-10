class CreateTopAlbums < ActiveRecord::Migration
  def self.up
    create_table :top_albums do |t|
      t.string   :name
      t.integer  :owner_id
      t.integer  :songs_count
      t.integer  :year
      t.string   :upc
      t.string   :avatar_file_name
      t.string   :avatar_content_type
      t.integer  :avatar_file_size
      t.datetime :avatar_updated_at
      t.string   :grid
      t.datetime :released_on
      t.string   :copyright
      t.string   :source
      t.integer  :label_id
      t.integer  :total_listens
      t.timestamps
    end
  end

  def self.down
    drop_table :top_albums
  end
end
