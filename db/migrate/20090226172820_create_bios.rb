class CreateBios < ActiveRecord::Migration
  def self.up
    create_table :bios do |t|
      t.integer  :account_id
      t.integer  :locale_id
      t.string   :short
      t.text     :long
      t.timestamps
    end

    add_index :bios, [:account_id, :locale_id]
    add_index :bios, [:account_id]
  end

  def self.down
    drop_table :bios
    remove_index :bios, :column => [:account_id, :locale_id]
    remove_index :bios, :column => [:account_id]
  end
end
