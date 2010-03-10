class AddInfluencesToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :influences, :text
  end

  def self.down
    remove_column :accounts, :influences
  end
end
