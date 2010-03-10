class CreatePlayersTable < ActiveRecord::Migration
  def self.up
    create_table :players do |t|
      t.string :player_key
      t.string :license
      t.integer :max_plays
      t.references :site
      t.timestamps
    end
  end

  def self.down
    drop_table :players
  end
end