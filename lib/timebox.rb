module Timebox
  def timebox(message)
    start_time = Time.now
    yield
    end_time = Time.now
    puts(message + " " + (end_time - start_time).to_s + " seconds")
  end
end