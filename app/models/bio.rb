# == Schema Information
#
# Table name: bios
#
#  id         :integer(4)      not null, primary key
#  account_id :integer(4)
#  short      :string(255)
#  long       :text
#  created_at :datetime
#  updated_at :datetime
#  locale     :string(255)
#

class Bio < ActiveRecord::Base
  validates_length_of :short, :maximum => 200
  index :account_id
  index [:id, :account_id]
  # index [:locale, :account_id]
  belongs_to :account
end
