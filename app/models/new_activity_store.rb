# == Schema Information
#
# Table name: new_activity_stores
#
#  id            :integer(4)      not null, primary key
#  account_id    :integer(4)
#  mine          :boolean(1)
#  activity_type :string(255)
#  data          :text
#  created_at    :datetime
#  updated_at    :datetime
#

class NewActivityStore < ActiveRecord::Base
  belongs_to :account

  default_scope :order => 'created_at DESC'
  
  def self.store(account, data, activity_type='listen', owners_record=nil)
    account_id = (account.kind_of?(Fixnum)) ? account : account.id
    create!(:account_id => account_id, :data => data.to_json, :activity_type => activity_type, :mine => (owners_record==true))
  end
end
