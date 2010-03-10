class CreateActivityStores < ActiveRecord::Migration
  def self.up
    create_table :activity_stores do |t|
      t.integer :account_id
      t.text :data
      t.datetime :created_at
    end
    
    add_index :activity_stores, :account_id
  end

  def self.down
    drop_table :activity_stores
  end
end
