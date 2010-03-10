class AddRadioEnabledCountriesTable < ActiveRecord::Migration
  def self.up
    create_table :radio_enabled_countries do |t|
      t.references :country
      t.boolean :available
      t.timestamps
    end
    add_index :radio_enabled_countries, [:country_id, :available]
  end

  def self.down
    drop_table :radio_enabled_countries
  end
end
