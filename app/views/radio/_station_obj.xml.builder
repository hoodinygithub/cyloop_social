xml.station do
  xml.type "99"
  xml.id @station_obj.id
  if @station_obj.has_attribute?('station_id')
    xml.idpl @station_obj.station_id
  elsif
    xml.idpl @station_obj.id
  end
  xml.name @station_obj.name
  xml.amgid @station_obj.amg_id
  xml.ip @source_ip
end
