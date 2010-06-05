namespace :db do
  namespace :populate do
    desc "Update user_stations with a fresh list of artists from rec engine"
    
    def refresh_artists_included_in(object = :user_stations)
      include Timebox

      conditions = "total_artists = 0 AND deleted_at IS NULL AND poll_attempts < 2#{ENV.has_key?('conditions') ? " AND #{ENV['conditions']}" : "" }"
      rec_engine = RecEngine.new(:ip_address => '67.63.37.2', :site => 'cyloop')
       
      options = { :klass => object.to_s.classify.constantize, :batch_size => 50, :order => 'id' }
      options = options.merge (:last_batch => ENV['last_batch'].to_i) if ENV.has_key?('last_batch') 
      options.merge!(:last_batch => ENV['last_batch'].to_i) if ENV.has_key?('last_batch') 
      options.merge!(:conditions => conditions)
      
      timebox "Running #{object.to_s} includes refresh" do
        batch = BolingForBatches::Batch.new(options)
        batch.run(:refresh_included_artists)
        batch.print_results
      end
    end
    
    # task :user_station_artists => :environment do      
    #   ENV['conditions'] = "AND abstract_station_id IN (#{ENV['artists'].split(/,/).map { |a| Artist.find_by_slug(a).station.id }.join(',') })" if ENV.has_key?('artists')
    #   ENV['conditions'] = "#{ENV.has_key?('artists') ? ENV['conditions'] + " AND ": ""}owner_id IN (#{ENV['users'].split(/,/).map { |a| User.find_by_slug(a).id }.join(',') })" if ENV.has_key?('users')
    #   
    #   refresh_artists_included_in :user_stations
    # end

    desc "Update stations with a fresh list of artists from rec engine"
    task :station_artists => :environment do
      ENV['conditions'] = "AND id IN (#{ENV['artists'].split(/,/).map { |a| Artist.find_by_slug(a).station.id }.join(',') })" if ENV.has_key?('artists')
      refresh_artists_included_in :abstract_stations
    end
  end
end
