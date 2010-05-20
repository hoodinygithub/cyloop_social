
module Application::Activities

  def self.included( base )
    base.send( :include, Application::Activities::InstanceMethods )
  end

  module InstanceMethods

    TYPES = {
      'listen'   => { :class => Song, :options => { :include => :album } },
      'twitter'  => Account,
      'status'   => Account,
      'station'  => { :class => Station, :options => { :include => :playable } },
      'playlist' => Playlist 
    }

    def load_related_item_activity( data )
      data.group_by { |a| a['type'] }.each do |activity_type, group|

        if ['twitter'].include?(activity_type)
          group.each { |item| item['item'] = { 'id' => item['account_id'] } }
        end

        if ['status'].include?(activity_type)
          group.each { |item| item['item'] = { 'id' => item['account']['id'] } }
        end        

        if TYPES[activity_type]
          group.reject! { |item| item.nil? || item['item'].nil? }
          item_ids = group.map { |item| item['item']['id'] }.uniq

          items = {}

          options = {}
          clazz = nil

          case TYPES[activity_type]
          when Hash
            clazz = TYPES[activity_type][:class]
            options = options.merge(TYPES[activity_type][:options])
          else
            clazz = TYPES[activity_type]
          end

          clazz.all( {:conditions => {:id => item_ids}}.merge(options) ).each do |item|
            items[item.id] = item
          end

          group.each do |activity|
            activity['record'] = items[activity['item']['id'].to_i]
          end
        end

      end
      data.reject! do |activity|
        TYPES[ activity['type'] ] && activity['record'].nil?
      end
      data
    end

    def record_listen_song_activity( song )
      ActivityProxy::Writer.new( current_user, song ).to_hash
    end

    def record_station_activity( station )
#       Supressing activity for now 2010-05-19 DZC
#       begin
#         artists_contained = station.playable.includes.map { |k| {:artist => k.artist.name, :slug => k.artist.slug} }.to_json rescue ''
#         tracker_payload = {
#           :user_id => current_user.id,
#           :station_id => station.id,
#           :site_id => current_site.id,
#           :visitor_ip_address => remote_ip,
#           :timestamp => Time.now.utc.to_i,
#           :artists_contained => artists_contained
#         }
#         Resque.enqueue(StationJob, tracker_payload)
#       rescue Exception => e
#         Rails.logger.error("*** Could not record station activity! payload: #{tracker_payload}") and return true
#       end
    end

    end

  end
