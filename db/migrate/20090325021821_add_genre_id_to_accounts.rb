class AddGenreIdToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :genre_id, :integer
  end

  def self.down
    remove_column :accounts, :genre_id
  end
end
