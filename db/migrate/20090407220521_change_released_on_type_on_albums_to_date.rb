class ChangeReleasedOnTypeOnAlbumsToDate < ActiveRecord::Migration
  def self.up
    execute('ALTER TABLE albums MODIFY COLUMN released_on DATE')
  end

  def self.down
    execute('ALTER TABLE albums MODIFY COLUMN released_on DATETIME')
  end
end
