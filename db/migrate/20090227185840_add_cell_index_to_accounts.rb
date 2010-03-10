class AddCellIndexToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :cell_index, :integer
  end

  def self.down
    remove_column :accounts, :cell_index
  end
end
