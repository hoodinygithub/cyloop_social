class CreateProfileVisits < ActiveRecord::Migration
  def self.up
    create_table :profile_visits do |t|
      t.references :owner
      t.references :visitor
      t.references :site
      t.integer :total_visits, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :profile_visits
  end
end
