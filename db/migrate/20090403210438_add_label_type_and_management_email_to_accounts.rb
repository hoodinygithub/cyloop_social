class AddLabelTypeAndManagementEmailToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :label_type, :string
    add_column :accounts, :management_email, :string
  end

  def self.down
    remove_column :accounts, :label_type
    remove_column :accounts, :management_email
  end
end
