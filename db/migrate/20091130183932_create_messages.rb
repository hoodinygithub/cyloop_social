class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.integer :id
      t.integer :chat_id
      t.string   :question
      t.string   :city
      t.string   :name
      t.integer :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :messages
  end
end

