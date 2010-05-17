# Activity::Tyrant
# 
# This is the Activity store Tyrant class. This is where we store the users
# activity feed.  This is namespaced to Activity::Tyrant because we have 
# about four other classes that have some form of Activity in the name.
# This is technical debt and we should rename this at some point to reflect
# the current activity.
#
# The tyrant table will look something like this, 1 being the account id:
#
#   1/activity/mine => {
#    'listen' => JSON
#    'station' => JSON
#   1/activity/with_friends => {
#     'listen' => JSON
#     'station' => JSON
#   }
#   1/activity/just_friends => {
#     'listen' => JSON
#     'station' => JSON
#   }

module Activity
  class Feed
    MAX_ITEMS = 200
    PER_PAGE = 15
    attr_reader :user, :source
    def self.query(*args)
      options = args.extract_options!
      page = PER_PAGE * (options[:page] - 1)
      per_page = options[:limit] || PER_PAGE 
      activity_type_for_query = if options[:for] == :all
        %w(station twitter status).join(' ')
      else
        options[:for].to_s
      end
      
      valid_after_timestamp  = options.has_key?(:after_timestamp)  && !options[:after_timestamp].to_i.zero? 
      valid_before_timestamp = options.has_key?(:before_timestamp) && !options[:before_timestamp].to_i.zero?

      db.query do |q| 
        q.add 'user_id', :numoreq, options[:account_ids].join(' ') unless options[:artist] && options[:account_ids].size != 1
        q.add 'account_id', :numeq, options[:artist] if options[:artist]
        q.add :timestamp, :numgt, options[:after_timestamp]  if valid_after_timestamp
        q.add :timestamp, :numlt, options[:before_timestamp] if valid_before_timestamp
        # q.add :type, :stroreq, activity_type_for_query <------ A lesson in pain
        q.add :type, :or, activity_type_for_query
        q.order_by :timestamp, :desc 
        q.limit per_page, page
      end
    end
    
    def self.dbs
      @dbs ||= []
      if @dbs.empty?
        TYRANT_CONFIG[:hosts].each do |host_port|
          host, port = host_port.split(':')
          @dbs.push Rufus::Tokyo::TyrantTable.new(host, port.to_i)
        end
      end
      @dbs
    end
    
    def self.random_db
      dbs[rand(dbs.size)]
    end
    
    # We set the tyrant database (actually a web service) as a class method
    # to negate the overhead of instantiating it every time we load a class.
    # There is then an instance method below to refer to the class invocation
    # of the database.
    def self.db
      @db ||= Rufus::Tokyo::TyrantTable.new(TWITTER_CONFIG[:ttserver_host], TWITTER_CONFIG[:ttserver_port])
    end

    # Shortcut to class database instance.
    def db
      @db ||= self.class.db
    end

    # Shortcut to db key so we can reference it as method rather than
    # instance variable in code.
    def key
      @key
    end
    
    # Load in the user and the type of activity we are looking for. This will
    # determine the key we use to refer to the activity feed.
    def initialize(user, activity_source = :mine, activity_kind = 'listen')
      @user   = user.kind_of?(Fixnum) ? user : user.id
      @source = activity_source
      @kind   = activity_kind.to_s
      @key    = "#{@user}/activity/#{@source}"
    end
    
    # Store the users activity feed
    def put(hash)
      Rails.logger.info hash.inspect
      key = [hash['user_id'], hash['type'], hash['timestamp']].join('/') # 340/listen/193842347
      db[key] = hash
    end

    # Get the activity ore return a blank json array
    def get
      db[key]
    end
    
    # Delete all activity
    def delete
      db.out(key)
    end
    
  end
end
