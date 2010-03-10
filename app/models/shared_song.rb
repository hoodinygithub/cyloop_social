# == Schema Information
#
# Table name: shared_songs
#
#  id              :integer(4)      not null, primary key
#  account_id      :integer(4)
#  song_id         :integer(4)      not null
#  sender_email    :string(255)     not null
#  recipient_email :string(255)     not null
#  created_at      :datetime
#  updated_at      :datetime
#

class SharedSong < ActiveRecord::Base
  belongs_to :song
  belongs_to :account

  validates_presence_of :recipient_email, :sender_email, :song_id

end
