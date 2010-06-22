class NetworkSite < ActiveRecord::Base
  belongs_to :network
  belongs_to :site
end
