module PlaylistsHelper
  
  def length_of_time_from_seconds(number_of_seconds)
    time     = Time.at(number_of_seconds).gmtime  
    hours    = time.strftime("%H")
    minutes  = time.strftime("%M")    
    seconds  = time.strftime("%S")    
    duration = [minutes, seconds]
    duration = [hours].concat(duration) if hours.to_i > 0 
    
    duration.map{ |t| t.rjust(2, '0') }.join(':')
  end
  
end