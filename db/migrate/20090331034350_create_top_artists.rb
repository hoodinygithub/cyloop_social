class CreateTopArtists < ActiveRecord::Migration
  def self.up
    create_table :top_artists do |t|
      t.string   :email
      t.string   :name
      t.string   :crypted_password
      t.string   :salt
      t.datetime :created_at
      t.datetime :updated_at
      t.string   :remember_token
      t.datetime :remember_token_expires_at
      t.string   :gender
      t.date     :born_on
      t.boolean  :marketing_opt_out
      t.string   :confirmation_code
      t.string   :slug
      t.string   :type
      t.text     :followee_cache
      t.string   :avatar_file_name
      t.string   :avatar_content_type
      t.integer  :avatar_file_size
      t.datetime :avatar_updated_at
      t.string   :amg_id
      t.integer  :city_id
      t.boolean  :receives_following_notifications
      t.text     :websites
      t.text     :bio
      t.integer  :entry_point_id
      t.string   :time_zone
      t.string   :color_header_bg
      t.string   :color_main_font
      t.string   :color_links
      t.string   :color_bg
      t.boolean  :private_profile
      t.integer  :cell_index
      t.string   :background_file_name
      t.string   :background_content_type
      t.integer  :background_file_size
      t.datetime :background_updated_at
      t.string   :background_align
      t.string   :background_repeat
      t.boolean  :background_fixed
      t.datetime :deleted_at
      t.integer  :created_by_id
      t.string   :status
      t.integer  :genre_id
      t.string   :default_locale
      t.integer  :label_id
      t.integer  :total_listens

      t.timestamps
    end
  end

  def self.down
    drop_table :top_artists
  end
end
