class CreateSharedSongs < ActiveRecord::Migration
  def self.up
    create_table :shared_songs do |t|
      t.integer :account_id
      t.integer :song_id, :null => false
      t.string :sender_email, :null => false
      t.string :recipient_email, :null => false
      t.timestamps
    end

    add_index :shared_songs, [ :account_id, :song_id, :recipient_email ]

  end

  def self.down
    drop_table :shared_songs
  end
end
