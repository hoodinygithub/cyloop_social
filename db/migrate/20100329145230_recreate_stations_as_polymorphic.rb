class RecreateStationsAsPolymorphic < ActiveRecord::Migration
  def self.up
    connection = ActiveRecord::Base.connection

    connection.execute "RENAME TABLE stations TO abstract_stations"

    create_table :user_station_artists do |t|
      t.references :user_station
      t.references :artist
      t.references :album
      t.timestamps
    end
    add_index :user_station_artists, [:user_station_id, :artist_id]
    add_index :user_station_artists, :artist_id

    ActiveRecord::Base.connection.execute "ALTER TABLE user_stations CHANGE COLUMN station_id abstract_station_id int(11)"

    create_table :abstract_station_artists do |t|
      t.references :abstract_station
      t.references :artist
      t.references :album
      t.timestamps
    end
    add_index :abstract_station_artists, [:abstract_station_id, :artist_id], :name => "index_asa_on_abstract_station_id_and_artist_id"
    add_index :abstract_station_artists, :artist_id, :name => "index_asa_on_artist_id"
    
    create_table :stations do |t|
      t.boolean :available, :null => false, :default => 1
      t.string  :playable_type, :limit => 25
      t.integer :playable_id
      t.timestamps 
    end
    add_index :stations, [:playable_type, :playable_id]

    create_table :editorial_stations do |t|
      t.string    :name
      t.boolean   :available
      t.integer   :mix_id
      t.timestamps 
      t.datetime  :deleted_at
      t.integer   :total_plays, :null => false, :default => 0
      t.integer   :total_artists, :null => false, :default => 0
    end
    add_index :editorial_stations, :mix_id
    
    create_table :editorial_stations_sites do |t|
      t.references  :editorial_station
      t.references  :site
      t.integer     :profile_id
      t.timestamps 
    end
    
    add_index :editorial_stations_sites, [:editorial_station_id, :site_id], :name => "index_ess_on_editorial_station_id_and_site_id"
    add_index :editorial_stations_sites, :site_id, :name => "index_ess_on_site_id"

    connection.execute "ALTER TABLE abstract_stations ADD total_plays int(11) NOT NULL DEFAULT 0, ADD total_artists int(11) NOT NULL DEFAULT 0"
    connection.execute "ALTER TABLE user_stations ADD total_plays int(11) NOT NULL DEFAULT 0, ADD total_artists int(11) NOT NULL DEFAULT 0"
    
    connection.transaction do
      connection.execute <<-EOF
      INSERT INTO stations
      SELECT id, available, 'AbstractStation', id, created_at, updated_at
      FROM abstract_stations
      WHERE amg_id IS NOT NULL
      EOF

      connection.execute <<-EOF
      INSERT INTO stations
      SELECT id, available, 'EditorialStation', id, created_at, updated_at
      FROM abstract_stations
      WHERE amg_id IS NULL
      EOF

      connection.execute <<-EOF
      INSERT INTO editorial_stations
      SELECT DISTINCT a.id, a.name, CASE WHEN s.site_id IS NULL THEN 0 ELSE 1 END, s.playlist_id, a.created_at, a.updated_at, CASE WHEN s.site_id IS NULL THEN now() ELSE NULL END, 0, 0
      FROM sites_stations s
      INNER JOIN abstract_stations a ON s.station_id = a.id
      EOF

      connection.execute <<-EOF
      INSERT INTO editorial_stations_sites(editorial_station_id, site_id, profile_id, created_at, updated_at)
      SELECT id, site_id, account_id, created_at, updated_at
      FROM sites_stations s
      WHERE site_id IS NOT NULL
      EOF

      connection.execute <<-EOF
      INSERT INTO stations (available, playable_type, playable_id, created_at, updated_at)
      SELECT 1, 'UserStation', id, created_at, updated_at
      FROM user_stations
      EOF

      connection.execute "DELETE FROM abstract_stations WHERE amg_id IS NULL"
    end

  end

  def self.down    
    drop_table :user_station_artists
    drop_table :abstract_station_artists
    drop_table :stations    
    connection.execute <<-EOF 
    INSERT INTO abstract_stations
    SELECT id, name, NULL, NULL, NULL, 0, created_at, updated_at, deleted_at, total_plays, total_artists
    FROM editorial_stations
    EOF
    drop_table :editorial_stations    
    drop_table :editorial_stations_sites    
    connection.execute "RENAME TABLE abstract_stations TO stations"
    connection.execute "ALTER TABLE abstract_stations DROP COLUMN total_plays, DROP COLUMN total_artists"
    connection.execute "ALTER TABLE user_stations DROP COLUMN total_plays, DROP COLUMN total_artists"
    ActiveRecord::Base.connection.execute "ALTER TABLE user_stations CHANGE COLUMN abstract_station_id station_id int(11)"
  end
end
