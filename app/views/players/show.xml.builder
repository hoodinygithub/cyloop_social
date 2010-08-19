xml.configs do 
  unless @configs.nil?
    xml.id         @configs.id 
    xml.player_key @configs.player_key
    xml.license    @configs.license
    xml.max_plays  @configs.max_plays
    xml.max_skips  @configs.max_skips
    xml.skip_duration @configs.skip_duration
  end
end
