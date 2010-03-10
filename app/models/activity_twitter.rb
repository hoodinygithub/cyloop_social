require 'rufus/tokyo/tyrant'
module Activity  
  class UndefinedKeyMember < StandardError; end
  class Twitter
    attr_reader :account, :id
    
    def initialize(account, id=nil)
      @account = account.kind_of?(Fixnum) ? account : account.id
      @id      = id
      @key     = "#{@account}/twitter/#{@id}"
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
      raise Actvity::UndefinedKeyMember if id.nil?      
      raise ArgumentError unless content.is_a?(Hash)            
      raise ArgumentError unless content[:timestamp]      
      db.merge!({key => content.merge({
        :id => id,  
        :user_id => account,
        :account_id => account,
        :type => 'twitter'                
      })})
    end
    
    def last
      result = db.query do |q| 
        q.order_by :id, :numdesc
        q.add :type, :eq, 'twitter'
        q.add :account_id, :numeq, account
        q.limit 1
      end
      result.first
    end
        
    def self.all
      db.query{|q| q.add :type, :eq, 'twitter' }
    end
    
    def self.last
      result = db.query do |q| 
        q.order_by :id, :numdesc
        q.add :type, :eq, 'twitter'
        q.limit 1
      end
      result.first
    end    
    
    def self.delete(key)
      db.delete(key)
    end
    
    def self.store(account, content)
      id          = content['id']            
      screen_name = content['user']['screen_name']
      twitter_id  = content['user']['id']      
      text        = content['text']
      created_at  = content['created_at']
      data        = {
        :screen_name => screen_name,
        :text => text,
        :timestamp => Time.parse(created_at).utc.to_i,
        :twitter_id => twitter_id
      }
      Activity::Twitter.new(account, id).put(data)
    end    
  end
end
