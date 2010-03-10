class CreateAccountsSites < ActiveRecord::Migration
  def self.up

    create_table :accounts_sites, :id => false do |t|
      t.integer :account_id, :null => false
      t.integer :site_id, :null => false
      t.timestamps
    end

    add_index :accounts_sites, [:account_id, :site_id], :unique => true
    add_index :accounts_sites, :site_id

  end

  def self.down

    drop_table :accounts_sites

  end
end
