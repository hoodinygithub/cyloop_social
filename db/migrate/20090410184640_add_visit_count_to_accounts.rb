class AddVisitCountToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :visit_count, :integer, :default => 0
  end

  def self.down
    remove_column :accounts, :visit_count
  end
end
