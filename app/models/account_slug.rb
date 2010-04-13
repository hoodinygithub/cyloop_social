# == Schema Information
#
# Table name: account_slugs
#
#  id         :integer(4)      not null, primary key
#  account_id :integer(4)      not null
#  slug       :string(255)     not null
#  created_at :datetime
#  updated_at :datetime
#


class AccountSlug < ActiveRecord::Base

  belongs_to :account
  validates_presence_of :account_id, :slug

end
