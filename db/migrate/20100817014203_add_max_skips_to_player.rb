class AddMaxSkipsToPlayer < ActiveRecord::Migration
  def self.up
    add_column :players, :max_skips, :integer
    add_column :players, :skip_duration, :integer
  end

  def self.down
    remove_column :players, :skip_duration
    remove_column :players, :max_skips
  end
end
