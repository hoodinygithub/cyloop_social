# == Schema Information
#
# Table name: activity_stores
#
#  id         :integer(4)      not null, primary key
#  account_id :integer(4)
#  data       :text
#  created_at :datetime
#

class Cyloop
  class Deprecated
    class ActivityStore < ActiveRecord::Base
      belongs_to :account

      default_scope :order => 'created_at DESC'

      def self.store(account, data, activity_type=nil, owners_record=nil)
        account_id = (account.kind_of?(Fixnum)) ? account : account.id
        if(activity_type.nil?)
          raw_data = JSON.parse(data.to_json)
          activity = JSON.parse(raw_data['activity'])
          activity_type = activity['type']
          owners_record = (account_id == activity['user']['id'])
        end
        activity_store = create!(:account_id => account_id, :data => data.to_json) rescue nil
        unless activity_store.nil?
          NewActivityStore.create!(:account_id => account_id, :data => data.to_json, :activity_type => activity_type, :mine => (owners_record==true))
          return activity_store
        end
      end
    end
  end
end