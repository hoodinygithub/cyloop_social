require 'httparty'

module Twitter
  class Status
    attr_accessor :message, :user_id, :timestamp
    def initialize( _message, _user_id, _timestamp )
      @message, @user_id, @timestamp = _message, _user_id, _timestamp
    end
  end  
    
  class Reader
    include HTTParty
    format :json
    
    def self.statuses(user_id, since_id=nil, count=200, page=1)
      params = { :page => page, :count => count } 
      unless since_id.nil?
        params[:since_id] = since_id
      end
      response = get("http://twitter.com/statuses/user_timeline/#{user_id}.json", :query => params)
    end
  end
end