
class MessengerLogin < ActiveRecord::Base

  validates_presence_of :site_id, :consent_token, :ip_address
  belongs_to :account

end