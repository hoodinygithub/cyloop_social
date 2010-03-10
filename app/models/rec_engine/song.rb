class RecEngine::Song < RecEngine::Abstract
  include Storage

  reader \
    :add_hoodmark_url,
    :album,
    :artist,
    :artist_amg_id,
    :category,
    :folder_name,
    :folder_name_url,
    :genre,
    :image,
    :label,
    :lyrics,
    :order,
    :partner_label,
    :song,
    :song_file,
    :subcategory,
    :user_type

  integer_reader :artist_id, :song_id
  integer_reader :song_year, :collection
  integer_reader :plays, :total_plays, :rating
  decimal_reader :total_rating

  boolean_reader :already_in_collection, :can_download, :can_rate

  alias id song_id
  alias title song

  def path
    song_file.split('=').last
  end

  def can_play?(country)
    read_attribute("can_play_#{country}") {|value| value.to_i.nonzero?}
  end

  def duration
    read_attribute("duration") do |string|
      components = string.split(':').map(&:to_i)
      value = components.inject(0) {|m,o| m*60+o}
      ActiveSupport::Duration.new(value, [:hours, :minutes, :seconds].zip(components))
    end
  end

  def to_s
    song
  end

end
