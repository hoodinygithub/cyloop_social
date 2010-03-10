class CreateWidgetApiKeys < ActiveRecord::Migration
  def self.up
    create_table :widget_api_keys do |t|
      t.string :api_key, :null => false
      t.string :name
      t.text   :description
      t.boolean :available, :default => true, :null => false
      t.timestamps
    end

    add_index :widget_api_keys, :api_key, :unique => true
    add_index :widget_api_keys, [ :available, :api_key ]

  end

  def self.down
    drop_table :widget_api_keys
  end
end
