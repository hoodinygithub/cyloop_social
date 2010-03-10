class CreateChats < ActiveRecord::Migration
  def self.up
    create_table :chats do |t|
      t.integer :id
      t.integer :artist_id
      t.datetime :chat_date
      t.timestamps
    end
  end

  def self.down
    drop_table :chats
  end
end

