
module Application::Activities

  def self.included( base )
    base.send( :include, Application::Activities::InstanceMethods )
  end

  module InstanceMethods

    TYPES = { 
      'listen' => {:class => Song, :options => { :include => :album } },
      'twitter' => Account,
      'station' => Station,
      'playlist' => Playlist }

    def load_related_item_activity( data )
      data.group_by { |a| a['type'] }.each do |activity_type, group|

        if activity_type == 'twitter'
          group.each { |item| item['item'] = { 'id' => item['account_id'] } }
        end

        if TYPES[activity_type]
          group.reject! { |item| item.nil? || item['item'].nil? }
          item_ids = group.map { |item| item['item']['id'] }
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

  end

end