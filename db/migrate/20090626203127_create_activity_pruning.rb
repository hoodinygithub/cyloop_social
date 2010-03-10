class CreateActivityPruning < ActiveRecord::Migration
  def self.up
    create_table :activity_pruning do |t|
      t.datetime :created_at
    end
    add_index :activity_pruning, :created_at
  end

  def self.down
    remove_table :activity_pruning
  end
end
