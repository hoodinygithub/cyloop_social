class FixIndiciesOnNewActivityStores < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.connection.execute "ALTER TABLE new_activity_stores ADD INDEX ix_new_activity_stores_account_id_activity_type_created_at (account_id, activity_type, created_at), DROP INDEX index_new_activity_stores_on_account_id_and_activity_type, DROP INDEX ix_new_activity_stores_account_id_activity_type_mine"
  end

  def self.down
    ActiveRecord::Base.connection.execute "ALTER TABLE new_activity_stores ADD INDEX index_new_activity_stores_on_account_id_and_activity_type (account_id, activity_type), ADD INDEX ix_new_activity_stores_account_id_activity_type_mine (account_id, activity_type, mine), DROP INDEX ix_new_activity_stores_account_id_activity_type_created_at"
  end
end
