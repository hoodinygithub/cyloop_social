class AddIndexToMessagesOnChatId < ActiveRecord::Migration
  def self.up
    add_index :messages, :chat_id
  end

  def self.down
    remove_index :messages, :column => :chat_id
  end
end

