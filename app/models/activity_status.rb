require 'rufus/tokyo/tyrant'
module Activity  
  class UndefinedKeyMember < StandardError; end

  class Status
    def initialize(account, id=nil)
      raise "Expecting an Account class but got a #{account.class}" unless account.is_a? Account
      @account    = account
      @account_id = account.id
      @id         = id
      @timestamp  = Time.now.to_i
      @key        = "#{@account_id}/status/#{@timestamp}"
    end
    
    def self.db
      @db ||= Rufus::Tokyo::TyrantTable.new(TWITTER_CONFIG[:ttserver_host], TWITTER_CONFIG[:ttserver_port])
    end
    
    def db
      @db ||= self.class.db      
    end
    
    def key
      @key
    end
        
    def put(content)
      raise ArgumentError unless content.is_a?(Hash)            
      db.merge!({key => content.merge({
        :id => id,  
        :user_id => @account_id,
        :user_avatar => @account.avatar.url(:tiny),
        :account_id => @account_id,
        :type => 'status',
        :user_slug => @account.slug,
        :timestamp => Time.now.to_i            
      })})
    end
    
    def last
      result = db.query do |q| 
        q.order_by :timestamp, :numdesc
        q.add :type, :eq, 'status'
        q.add :account_id, :numeq, @account_id
        q.limit 1
      end
      result.first
    end
    
    def latest_with_followings(args = {})
      args.merge!({:include_followings => true})
      latest(args)
    end
    
    def latest(args = {})
      args[:limit] ||= 6
      
      result = db.query do |q| 
        q.order_by :timestamp, :numdesc
        q.add :type, :eq, 'status'
        
        q.add :timestamp, :numgt, args[:after_timestamp]  if args[:after_timestamp]
        q.add :timestamp, :numlt, args[:before_timestamp] if args[:before_timestamp]

        if args[:include_followings]
          accounts = @account.following_ids
          accounts << @account_id
          q.add 'user_id', :numoreq, accounts.join(" ")
        else
          q.add :account_id, :numeq, @account_id
        end
        
        q.limit args[:limit]
      end
      
      result.each do |r|
        r['user'] = User.find(r['account_id'])
      end
      
      result
    end
    
    def all
      db.query do |q|
        q.add :type, :eq, 'status'
        q.add :account_id, :numeq, @account_id
      end
    end
              
    def self.all
      db.query{|q| q.add :type, :eq, 'status' }
    end
    
    def self.last
      result = db.query do |q| 
        q.order_by :id, :numdesc
        q.add :type, :eq, 'status'
        q.limit 1
      end
      result.first
    end    
    
    def self.delete(key)
      db.delete(key)
    end
    
    def self.store(account, content)
      data        = {
        :message => content[:message],
        :timestamp => Time.parse(created_at).utc.to_i,
      }
      Activity::Status.new(account, id).put(data)
    end    
  end
end
