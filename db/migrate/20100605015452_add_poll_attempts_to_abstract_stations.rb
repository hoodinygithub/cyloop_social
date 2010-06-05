class AddPollAttemptsToAbstractStations < ActiveRecord::Migration
  def self.up
    add_column :abstract_stations, :poll_attempts, :integer, :null => false, :default => 0
  end

  def self.down
    remove_column :abstract_stations, :poll_attempts
  end
end
