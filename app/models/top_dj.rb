class TopDj < ActiveRecord::Base
  include Db::Predicates::LimitedTo
  include Summary::Predicates
  belongs_to :site
  belongs_to :user, :foreign_key => 'dj_id'
end
