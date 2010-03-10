module DurationsHelper
  
  def seconds_to_duration(time)
    unless time.nil?
      time = [time/60, time % 60].map{|t| t.to_s.rjust(2, '0')}.join(':')
      time[1,4] if time[0].chr == "0"
    else
      I18n.t('basics.unknown')
    end
  end
end