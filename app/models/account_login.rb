# == Schema Information
#
# Table name: account_logins
#
#  id         :integer(4)      not null, primary key
#  account_id :integer(4)      not null
#  site_id    :integer(4)      not null
#  created_at :datetime        not null
#


class AccountLogin < ActiveRecord::Base

  belongs_to :account
  belongs_to :site

  validates_presence_of :account_id, :site_id

end
