class RevertRadioEnabledCountriesTable < ActiveRecord::Migration
  def self.up
    drop_table :radio_enabled_countries
    add_column :countries, :enable_radio, :boolean, :default => false, :null => false
  end

  def self.down
    remove_column :countries, :enable_radio
    create_table :radio_enabled_countries do |t|
      t.references :country
      t.boolean :available
      t.timestamps
    end
    add_index :radio_enabled_countries, [:country_id, :available]
  end
end
