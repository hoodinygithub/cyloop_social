class CreateNewActivityStores < ActiveRecord::Migration
 def self.up
   create_table :new_activity_stores do |t|
     t.integer :account_id
     t.boolean :mine
     t.string :activity_type
     t.text :data
     t.timestamps
   end
   add_index :new_activity_stores, [:account_id, :activity_type]
   add_index :new_activity_stores, [:account_id, :activity_type, :mine], :name => 'ix_new_activity_stores_account_id_activity_type_mine'
 end

 def self.down
   drop_table :new_activity_stores
 end
end