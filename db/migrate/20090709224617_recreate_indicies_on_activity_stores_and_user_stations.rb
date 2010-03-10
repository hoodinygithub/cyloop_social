class RecreateIndiciesOnActivityStoresAndUserStations < ActiveRecord::Migration
  def self.up
    remove_index :activity_stores, :column => :account_id rescue say "index exists on activity_stores account_id"
    add_index :activity_stores, [:account_id, :created_at] rescue say "index exists on activity_stores on account_id and created_at"
    remove_index :user_stations, :column => :owner_id rescue say "index exists on user_stations on owner_id"
    add_index :user_stations, [:owner_id, :created_at] rescue say "index exists on user_stations on owner_id and created_at"
    remove_index :new_activity_stores, :column => :account_id rescue say "index exists on new_activity_stores on account_id"
    add_index :new_activity_stores, [:account_id, :created_at] rescue say "index exists on new_activity_stores on account_id and created_at"
  end

  def self.down
    remove_index :activity_stores, :column => [:account_id, :created_at]
    add_index :activity_stores, :account_id
    remove_index :user_stations, :column => [:owner_id, :created_at]
    add_index :user_stations, :owner_id
    remove_index :new_activity_stores, :column => [:account_id, :created_at] rescue puts "Index exists"
    add_index :new_activity_stores, :account_id
  end
end
