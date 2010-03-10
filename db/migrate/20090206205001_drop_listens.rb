class DropListens < ActiveRecord::Migration
  def self.up
    drop_table :listens
  end

  def self.down
    create_table "listens", :force => true do |t|
      t.integer  "song_id"
      t.integer  "listener_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
end
