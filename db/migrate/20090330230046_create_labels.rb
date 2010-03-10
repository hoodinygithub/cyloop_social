class CreateLabels < ActiveRecord::Migration
  def self.up
    create_table :labels do |t|
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :labels
  end
end
