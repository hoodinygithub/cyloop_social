
class AccountSlug < ActiveRecord::Base

  belongs_to :account
  validates_presence_of :account_id, :slug

end