# == Schema Information
#
# Table name: messenger_logins
#
#  id            :integer(4)      not null, primary key
#  account_id    :integer(4)
#  site_id       :integer(4)      not null
#  consent_token :string(255)     not null
#  ip_address    :string(255)     not null
#  created_at    :datetime
#  updated_at    :datetime
#


class MessengerLogin < ActiveRecord::Base

  validates_presence_of :site_id, :consent_token, :ip_address
  belongs_to :account

end
