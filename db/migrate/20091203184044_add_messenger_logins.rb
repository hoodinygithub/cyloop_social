class AddMessengerLogins < ActiveRecord::Migration

  def self.up

    create_table :messenger_logins do |t|
      t.integer :account_id
      t.integer :site_id, :null => false
      t.string :consent_token, :null => false
      t.string :ip_address, :null => false
      t.timestamps
    end

  end

  def self.down
    drop_table :messenger_logins
  end
  
end