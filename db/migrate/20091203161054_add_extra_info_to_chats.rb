class AddExtraInfoToChats < ActiveRecord::Migration
  def self.up
    add_column :chats, :markets, :string
    add_column :chats, :status, :string
    add_column :chats, :profile_id, :integer
    
    add_index :chats, :profile_id
    add_index :chats, :status
    add_index :chats, :artist_id
  end

  def self.down
    remove_index :chats, :artist_id
    remove_index :chats, :status
    remove_index :chats, :profile_id

    remove_column :chats, :profile_id
    remove_column :chats, :status
    remove_column :chats, :markets
  end
end
