#0-59/10 * * * * cd /data/latam/current && RAILS_ENV=staging rake twitter:follow_pending_accounts
#0-59/2 * * * * cd /data/latam/current && RAILS_ENV=staging rake twitter:fetch_friends_timeline
namespace :twitter do
  task :all => [:unfollow_removed_accounts, :follow_pending_accounts, :fetch_friends_timeline] do
    puts "--"
    puts "Twitter tasks finished (unfollow, follow and timeline updated)"
  end

  def fetch_feed( account )
    screen_name = account.twitter_username;
    activity    = Activity::Twitter.new(account.id)
    since_id    = ENV['since_id'] || File.read("#{RAILS_ROOT}/log/TWITTER_LAST_ID").to_i || 1
    statuses    = Twitter::Reader.statuses(screen_name, since_id)
    puts "#{statuses.size} statuses from #{screen_name}"
    statuses.each do |status|
      begin
        Activity::Twitter::store(account, status)
      rescue Exception => ex
        puts "#{status.inspect} (#{screen_name}) #{ex.inspect}"
        HoptoadNotifier.notify(ex)
      end
    end
  end

  desc "Record the sound of last tweets using the rss feed"
  task :fetch_from_feeds => :environment do
    conditions = [ 'deleted_at is null and twitter_id is not null' ]
    if ENV['TWITTER']
      conditions <<  "twitter_username = '#{ENV['TWITTER']}'"
    end
    
    if ENV['IGNORE']
      ignore = ENV['IGNORE'].split(',').join("','")
      conditions << "twitter_username NOT IN ('#{ignore}')"
    end
    Account.find_each(
      :conditions => conditions.join(" AND "),
      :select => 'id, twitter_username, avatar_content_type') do |account|
      fetch_feed( account )
    end
  end
  
  desc "Unfollow removed users to reduce some noise from TT"
  task :unfollow_removed_accounts => :environment do        
    @twitter ||= Twitter::Cyloop.new
    if @twitter.authorized
      accounts = Account.all :conditions => 'deleted_at is not null and twitter_id is not null', :limit => 10
      old_friends   = []
      error_friends = []      
      accounts.each do |account|
        info = @twitter.unfriend(account.twitter_username.sub(" ",""))
        unless info['error']
          if account.update_attribute(:twitter_id, nil)
            old_friends << account.twitter_username        
          end
        else
          error_friends << account.twitter_username
        end
      end
      puts "Unfollowed: #{old_friends.join(",")}"   if old_friends.size > 0
      puts "Errors:     #{error_friends.join(",")}" if error_friends.size > 0
      puts "Unfollow removed users: Finished"
    end
  end
  
  desc "Follow users that recent update their twitter usernames and beanstalk job didn't update"
  task :follow_pending_accounts => :environment do    
    ignore   = ENV['ignore'].to_s.split(",")
    ign_cond = "and twitter_username not in ('#{ignore.join("','")}')"
    
    @twitter ||= Twitter::Cyloop.new
    if @twitter.authorized
      # Find users without a twitter_id to follow
      accounts = Account.all(:conditions => %%
        deleted_at is null and 
        twitter_id is null and 
        twitter_username is not null and 
        twitter_username <> '' #{ignore.size > 0 ? ign_cond : ''}
        %, :limit => 50)
      # puts "##{accounts.size} new pending friends found!"
      new_friends   = []
      error_friends = []
      accounts.each do |account|
        next if account.twitter_username =~ / /
        info = @twitter.friend(account.twitter_username)
        unless info['error']
          if account.update_attribute(:twitter_id, info['id'])
            # puts "Friendship with #{account.twitter_username} done!"
            new_friends << account.twitter_username
          end
        else
          puts "#{info['error']} (@#{account.twitter_username})"          
          if account.is_a?(Artist) && info['error'] != "#{account.twitter_username} is already on your list"
            account.update_attribute(:twitter_username, nil)
          end
          error_friends << account.twitter_username
        end
      end
      puts "Friends: #{new_friends.join(",")}"   if new_friends.size > 0
      puts "Errors:  #{error_friends.join(",")}" if error_friends.size > 0    
      puts "Follow users that recent update their twitter usernames: Finished"
    end
  end
  
  desc "Update timeline getting last tweets since the last tweet (limit 200/request)"
  task :fetch_friends_timeline => :environment do
    twitter_id_file = "#{RAILS_ROOT}/log/TWITTER_LAST_ID"
    since_id = ENV['since_id'] || File.read(twitter_id_file).to_i || 1    
    puts "Fetching statuses since ID ##{since_id}"
    @twitter ||= Twitter::Cyloop.new
    statuses = @twitter.friends_timeline(since_id, 200, ENV['page'])
    puts "##{statuses.size} statuses found"
    begin
      unless statuses.empty?
        statuses.each do |status|
          account = Account.find_by_twitter_id(status['user']['id'])
          unless account.nil?
            Activity::Twitter::store(account, status)
            Resque.enqueue(TrimJob, :account_id => account.id)
            puts "@#{status['user']['screen_name']}: #{status['text']}"
          else
            puts "There is no account with @#{status['user']['screen_name']} (#{status['user']['id']})"
          end
        end
        last_id = statuses.max {|a,b| a['id'].to_i <=> b['id'].to_i}
        File.open(twitter_id_file, 'w+') {|f| f.write(last_id['id']) }
      end
    rescue Exception => ex
      puts "Error: #{statuses['error'] rescue ex.message}"
      puts "---"
      puts ex.backtrace
      puts "---"
      HoptoadNotifier.notify(ex)
    end
  end
  
  namespace :tyrant do
    desc "Start tyrant. Not really for use in production environment."
    task :start => 'twitter:tyrant:stop' do
      `rm -rf #{RAILS_ROOT}/db/tyrant/twitter.#{RAILS_ENV}.pid`
      ttcomand = "ttserver -dmn "
      ttcomand << "-port #{TWITTER_CONFIG[:ttserver_port]} "
      ttcomand << "-log #{RAILS_ROOT}/log/twitter.tyrant.#{RAILS_ENV}.log "
      ttcomand << "-pid #{RAILS_ROOT}/db/tyrant/twitter.#{RAILS_ENV}.pid "
      ttcomand << "#{RAILS_ROOT}/db/tyrant/twitter.#{RAILS_ENV}.tct"
      puts ttcomand
      system ttcomand
      pid = `cat #{RAILS_ROOT}/db/tyrant/twitter.#{RAILS_ENV}.pid`
      puts "Running ttserver in #{RAILS_ENV} environment with pid #{pid}"
    end

    task :stop => :environment do
      `kill -TERM \`cat #{RAILS_ROOT}/db/tyrant/twitter.#{RAILS_ENV}.pid\``
    end    
  end
end
