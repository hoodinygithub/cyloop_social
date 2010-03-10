class AddLoginTypesTable < ActiveRecord::Migration
  def self.up
    create_table :login_types do |t|
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :login_types
  end
end
