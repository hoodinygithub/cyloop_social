class FixIndexesOnWidgetApiKeys < ActiveRecord::Migration
  def self.up
    remove_index :widget_api_keys, :api_key
    remove_index :widget_api_keys, [ :available, :api_key ]
    add_index :widget_api_keys, [ :api_key, :available ]
  end

  def self.down
    add_index :widget_api_keys, :api_key, :unique => true
    add_index :widget_api_keys, [ :available, :api_key ]
  end
end
