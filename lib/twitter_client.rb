module Twitter  
  class Client  
    def self.client
      @client ||= TwitterOAuth::Client.new({
        :consumer_key => TWITTER_CONFIG[:consumer_key],
        :consumer_secret => TWITTER_CONFIG[:consumer_secret]
      })
    end
    
    def client
      @client ||= self.class.client
    end
  
    def authorized
      @authorized
    end
  
    def friends(page=1)
      client.friends(page)
    end
    
    def friends_ids
      client.friends_ids
    end
  
    def friend(friend_id)
      client.friend(friend_id)
    end
    
    def unfriend(friend_id)
      client.unfriend(friend_id)
    end    
    
    def update(text)
      client.update(text)
    end
  
    def find(id)
      response = client.show(id)
      raise Twitter::NotFound, response["error"] if response["error"]
      response
    end
  
    def friends_timeline(since_id, count=200, page=1)
      client.friends_timeline(:since_id => since_id, :count => count, :page => page)
    end
  end
  
  class Cyloop < Client
    def initialize
      @authorized = client.authorized?
    end
  
    def self.client
      @client ||= TwitterOAuth::Client.new({
        :consumer_key => TWITTER_CONFIG[:consumer_key],
        :consumer_secret => TWITTER_CONFIG[:consumer_secret],
        :token => TWITTER_CONFIG[:token],
        :secret => TWITTER_CONFIG[:secret]      
      })
    end    
  end
end