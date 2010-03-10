# == Schema Information
#
# Table name: raw_song_plays
#
#  id                  :integer(4)      not null, primary key
#  duration            :integer(4)
#  created_at          :datetime
#  source              :string(255)
#  country_id          :integer(4)
#  listener_id         :integer(4)
#  song_id             :integer(4)
#  site_id             :integer(4)
#  listener_ip_address :string(255)
#  full                :boolean(1)
#  station_id          :integer(4)
#

# THIS CLASS IS NOT AVAILABLE IN THE CYLOOP APPLICATION
# IT CAN ONLY BE USED IN THE BIG BROTHER APPLICATION FOR
# TRACKING OF SONG LISTENS AND REPORTING
class RawSongPlay < ActiveRecord::Base
  belongs_to :listener, :class_name => 'Account'
  belongs_to :song
  belongs_to :site
  
end
