class CreateLocales < ActiveRecord::Migration
  def self.up
    create_table :locales do |t|
      t.integer :country_id
      t.string :name
      t.string :code
      t.boolean :supported, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :locales
  end
end
