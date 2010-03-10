class ChangeAccountsSitesTableName < ActiveRecord::Migration

  def self.up
    rename_table :accounts_sites, :accounts_excluded_sites

    remove_index :accounts_excluded_sites, :name => 'index_accounts_sites_on_site_id'
    remove_index :accounts_excluded_sites, :name => 'index_accounts_sites_on_account_id_and_site_id'

    add_index :accounts_excluded_sites, [:site_id, :account_id], :unique => true

  end

  def self.down

    remove_index :accounts_excluded_sites, [:site_id, :account_id]

    rename_table :accounts_excluded_sites, :accounts_sites

    add_index :accounts_sites, :site_id
    add_index :accounts_sites, [:account_id, :site_id], :unique => true

  end

end
