xml.stations do
  @stations.each do |station|
    xml.station do
      xml.id station.id
      xml.type 99
      xml.station_url "#{RecEngine::BASE_URI}?request=getRecEnginePlayList&artistID=#{station.amg_id}&userID=#{current_user.id}&ipAddress=#{@source_ip}"
      xml.idpl station.station_id
      xml.name station.name
    end
  end
end
