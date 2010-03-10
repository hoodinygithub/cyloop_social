class CreateAccountsSlugs < ActiveRecord::Migration

  def self.up
    create_table :account_slugs do |t|
      t.integer :account_id, :null => false
      t.string :slug, :null => false
      t.timestamps
    end

    add_index :account_slugs, [:account_id, :slug], :unique => true
    add_index :account_slugs, :slug, :unique => true
  end

  def self.down
    drop_table :account_slugs
  end
  
end