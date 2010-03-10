class AddResetCodeToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :reset_code, :string
  end

  def self.down
    remove_column :accounts, :reset_code
  end
end
