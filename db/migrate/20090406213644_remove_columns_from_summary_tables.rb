class RemoveColumnsFromSummaryTables < ActiveRecord::Migration
  def self.up
    remove_column :top_songs, :title
    remove_column :top_songs, :artist_id
    remove_column :top_songs, :duration
    remove_column :top_songs, :copyright
    remove_column :top_songs, :label
    remove_column :top_songs, :distributor
    remove_column :top_songs, :file_name
    remove_column :top_songs, :album_id
    remove_column :top_songs, :position
    remove_column :top_songs, :source
    remove_column :top_albums, :name
    remove_column :top_albums, :owner_id
    remove_column :top_albums, :songs_count
    remove_column :top_albums, :year
    remove_column :top_albums, :upc
    remove_column :top_albums, :avatar_file_name
    remove_column :top_albums, :avatar_content_type
    remove_column :top_albums, :avatar_file_size
    remove_column :top_albums, :avatar_updated_at
    remove_column :top_albums, :grid
    remove_column :top_albums, :released_on
    remove_column :top_albums, :copyright
    remove_column :top_albums, :source
    remove_column :top_albums, :label_id
    remove_column :top_stations, :name
    remove_column :top_stations, :amg_id
    remove_column :top_stations, :artist_id
    remove_column :top_stations, :includes_cache
    remove_column :top_stations, :available
    remove_column :top_stations, :order
    remove_column :top_artists, :email
    remove_column :top_artists, :name
    remove_column :top_artists, :crypted_password
    remove_column :top_artists, :salt
    remove_column :top_artists, :remember_token
    remove_column :top_artists, :remember_token_expires_at
    remove_column :top_artists, :gender
    remove_column :top_artists, :born_on
    remove_column :top_artists, :marketing_opt_out
    remove_column :top_artists, :confirmation_code
    remove_column :top_artists, :slug
    remove_column :top_artists, :type
    remove_column :top_artists, :followee_cache
    remove_column :top_artists, :avatar_file_name
    remove_column :top_artists, :avatar_content_type
    remove_column :top_artists, :avatar_file_size
    remove_column :top_artists, :avatar_updated_at
    remove_column :top_artists, :amg_id
    remove_column :top_artists, :city_id
    remove_column :top_artists, :receives_following_notifications
    remove_column :top_artists, :websites
    remove_column :top_artists, :bio
    remove_column :top_artists, :entry_point_id
    remove_column :top_artists, :time_zone
    remove_column :top_artists, :color_header_bg
    remove_column :top_artists, :color_main_font
    remove_column :top_artists, :color_links
    remove_column :top_artists, :color_bg
    remove_column :top_artists, :private_profile
    remove_column :top_artists, :cell_index
    remove_column :top_artists, :background_file_name
    remove_column :top_artists, :background_content_type
    remove_column :top_artists, :background_file_size
    remove_column :top_artists, :background_updated_at
    remove_column :top_artists, :background_align
    remove_column :top_artists, :background_repeat
    remove_column :top_artists, :background_fixed
    remove_column :top_artists, :deleted_at
    remove_column :top_artists, :created_by_id
    remove_column :top_artists, :status
    remove_column :top_artists, :genre_id
    remove_column :top_artists, :default_locale
    remove_column :top_artists, :label_id
  end

  def self.down
    add_column :top_songs, :title, :string
    add_column :top_songs, :artist_id, :integer
    add_column :top_songs, :duration, :integer
    add_column :top_songs, :copyright, :string
    add_column :top_songs, :label, :string
    add_column :top_songs, :distributor, :string
    add_column :top_songs, :file_name, :string
    add_column :top_songs, :album_id, :integer
    add_column :top_songs, :position, :integer
    add_column :top_songs, :source, :string
    add_column :top_albums, :name, :string
    add_column :top_albums, :owner_id, :integer
    add_column :top_albums, :songs_count, :integer
    add_column :top_albums, :year, :integer
    add_column :top_albums, :upc, :string
    add_column :top_albums, :avatar_file_name, :string
    add_column :top_albums, :avatar_content_type, :string
    add_column :top_albums, :avatar_file_size, :integer
    add_column :top_albums, :avatar_updated_at, :datetime
    add_column :top_albums, :grid, :string
    add_column :top_albums, :released_on, :datetime
    add_column :top_albums, :copyright, :string
    add_column :top_albums, :source, :string
    add_column :top_albums, :label_id, :integer
    add_column :top_stations, :name, :string
    add_column :top_stations, :amg_id, :string
    add_column :top_stations, :artist_id, :integer
    add_column :top_stations, :includes_cache, :string
    add_column :top_stations, :available, :boolean
    add_column :top_stations, :order, :integer
    add_column :top_artists, :email, :string
    add_column :top_artists, :name, :string
    add_column :top_artists, :crypted_password, :string
    add_column :top_artists, :salt, :string
    add_column :top_artists, :remember_token, :string
    add_column :top_artists, :remember_token_expires_at, :datetime
    add_column :top_artists, :gender, :string
    add_column :top_artists, :born_on, :datetime 
    add_column :top_artists, :marketing_opt_out, :boolean
    add_column :top_artists, :confirmation_code, :string
    add_column :top_artists, :slug, :string
    add_column :top_artists, :type, :string
    add_column :top_artists, :followee_cache, :string
    add_column :top_artists, :avatar_file_name, :string
    add_column :top_artists, :avatar_content_type, :string
    add_column :top_artists, :avatar_file_size, :string
    add_column :top_artists, :avatar_updated_at, :datetime
    add_column :top_artists, :amg_id, :string
    add_column :top_artists, :city_id, :integer
    add_column :top_artists, :receives_following_notifications, :boolean
    add_column :top_artists, :websites, :string
    add_column :top_artists, :bio, :string
    add_column :top_artists, :entry_point_id, :integer
    add_column :top_artists, :time_zone, :string
    add_column :top_artists, :color_header_bg, :string
    add_column :top_artists, :color_main_font, :string
    add_column :top_artists, :color_links, :string
    add_column :top_artists, :color_bg, :string
    add_column :top_artists, :private_profile, :boolean
    add_column :top_artists, :cell_index, :integer
    add_column :top_artists, :background_file_name, :string
    add_column :top_artists, :background_content_type, :string
    add_column :top_artists, :background_file_size, :integer
    add_column :top_artists, :background_updated_at, :datetime
    add_column :top_artists, :background_align, :string
    add_column :top_artists, :background_repeat, :string
    add_column :top_artists, :background_fixed, :string
    add_column :top_artists, :deleted_at, :datetime
    add_column :top_artists, :created_by_id, :integer
    add_column :top_artists, :status, :string
    add_column :top_artists, :genre_id, :integer
    add_column :top_artists, :default_locale, :string
    add_column :top_artists, :label_id, :integer
  end
end
