class CreateListens < ActiveRecord::Migration
  def self.up
    create_table :listens do |t|
      t.integer :song_id
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :listens
  end
end
