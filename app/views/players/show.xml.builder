xml.configs do 
  unless @configs.nil?
    xml.id         @configs.id 
    xml.player_key @configs.player_key
    xml.license    @configs.license
    xml.max_plays  @configs.max_plays
  end
end
