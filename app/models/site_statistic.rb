# == Schema Information
#
# Table name: site_statistics
#
#  id                         :integer(4)      not null, primary key
#  site_id                    :integer(4)
#  total_artists              :integer(4)      default(0)
#  total_songs                :integer(4)      default(0)
#  total_users                :integer(4)      default(0)
#  total_registrations        :integer(4)      default(0)
#  total_global_users         :integer(4)      default(0)
#  total_global_registrations :integer(4)      default(0)
#

class SiteStatistic < ActiveRecord::Base
  belongs_to :site
end
