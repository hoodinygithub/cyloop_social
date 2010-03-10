# Took all this out of the account model -jason

# def activity_feed
#   # @activity_feed ||= ActivityFeed.new(self)
#   data = ActivityStore.find(:all, :conditions => {:account_id => self.id}, :select => 'data').map{|a| a.data}
#   formatted_json = "[" + data.join(',') + "]"
#   activity_feed ||= formatted_json
# end
# 
# has_many :activity_stores
# def parsed_activity_feed(type = 'listen', show_user = true, show_friends = false)
# 
#   raw_data = activity_stores.find(:all, :select => 'data', :limit => 200).map{|a| JSON.parse(a.data)}
#   data = raw_data.map do |raw_item| 
#     raw_item['activity'] = JSON.parse(raw_item['activity']) rescue ''
#     raw_item
#   end.reject{|item| item['activity'].blank?}
#   if !show_friends
#     data.reject!{|item| item['activity']['user']['id'] != self.id && !self.artist?}
#   end
#   if !show_user
#     data.reject!{|item| item['activity']['user']['id'] == self.id && !self.artist?}
#   end
#   parsed_activity_feed ||= data || []
# end
# 
# has_many :new_activity_stores
# def new_parsed_activity_feed( options = {} )
#   options = { :type => 'listen', :show_user => true, :show_friends => false }.merge(options)
#   type           = options[:type]
#   show_user      = options[:show_user]
#   show_friends   = options[:show_friends]
#   timestamp      = options[:timestamp].to_i
#   skip_timestamp = options[:skip_timestamp].to_i
#   page           = options[:page] || 1
#   activity       = []
#   cond           = []
#   data           = []
#   
#   index_name = 'index_new_activity_stores_on_account_id_and_created_at'
#   unless(type=='all')
#     index_name = 'ix_new_activity_stores_account_id_activity_type_created_at'
#   end
#      
#   cond.push("activity_type = '#{type}'") unless(type=='all')
#   cond.push("mine IS true") if(show_user && !show_friends)
#   cond.push("mine IS false") if (!show_user && show_friends)
#   if timestamp > 0
#     since_date = Time.at(timestamp).utc
#     cond.push("created_at > '#{since_date.year}-#{since_date.month}-#{since_date.day} #{since_date.hour}:#{since_date.min}:#{since_date.sec}'")
#   end
#   if skip_timestamp > 0
#     before_date = Time.at(skip_timestamp).utc
#     cond.push("created_at < '#{before_date.year}-#{before_date.month}-#{before_date.day} #{before_date.hour}:#{before_date.min}:#{before_date.sec}'")
#   end
#   
#   activity = new_activity_stores.all(:from => "#{NewActivityStore.quoted_table_name} USE INDEX (#{index_name})", :conditions => "#{cond.join(' AND ')}", :select => 'data, created_at', :limit => 100)
# 
#   raw_data = activity.map{|a| b = JSON.parse(a.data); b['row_timestamp'] = a.created_at.to_i; b }
#   
#   data = raw_data.map do |raw_item| 
#     raw_item['activity']  = JSON.parse(raw_item['activity']) rescue ''
#     raw_item
#   end.reject{|item| item['activity'].blank?}    
#   
#   if type == "all" && options[:disable_twitter] != true
#     data.concat(twitter_feed(:show_user => show_user,
#                              :show_friends => show_friends,
#                              :page => page,
#                              :limit => 15,
#                              :timestamp => timestamp,
#                              :skip_timestamp => skip_timestamp))
#     data.sort!{|x,y| 
#       w = x['timestamp'].to_i != 0 ? x['timestamp'].to_i : x['activity']['timestamp'].to_i
#       z = y['timestamp'].to_i != 0 ? y['timestamp'].to_i : y['activity']['timestamp'].to_i
#       z <=> w
#     }
#   end
#   
#   data
# end
# 
# def cached_activity_feed(show_friends = true)
#   Rails.cache.fetch("user-#{self.id}-raw-activity-feed-#{show_friends}") do
#     self.activity_feed.lines(nil, show_friends)
#   end
# end
