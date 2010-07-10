class TopPlaylist < ActiveRecord::Base
  include Db::Predicates::LimitedTo
  include Summary::Predicates
  belongs_to :site
  belongs_to :playlist
end
