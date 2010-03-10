class AddPreSubmittedToMessages < ActiveRecord::Migration
  def self.up
    add_column :messages, :pre_submitted, :boolean
  end

  def self.down
    remove_column :messages, :pre_submitted
  end
end

