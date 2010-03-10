module Station::IncludesCache

  def self.included(base)
    base.class_eval do
      serialize :includes_cache, Array
    end
  end

  def update_includes_cache(params={})
    cache = RecEngine.new.get_similar_artists(:artistID => params[:amgID].to_s, :number_of_records => params[:number_of_records]).map { |i|
      Artist.find_by_slug(i.slug).try(:id)
    }.compact
    update_attribute(:includes_cache, cache)
  rescue SocketError
    logger.error "RecEngine timed out"
    []
  end


  def includes_cache
   read_attribute(:includes_cache) || write_attribute(:includes_cache, [])
  end

end
