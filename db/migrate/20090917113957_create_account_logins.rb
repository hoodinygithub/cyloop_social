class CreateAccountLogins < ActiveRecord::Migration
  def self.up
    
    create_table :account_logins do |t|
      t.integer :account_id, :null => false
      t.integer :site_id, :null => false
      t.datetime :created_at, :null => false
    end
    
    add_index :account_logins, [:account_id, :created_at]
    add_index :account_logins, [:site_id, :created_at]
  end

  def self.down
    drop_table :account_logins
  end
end
