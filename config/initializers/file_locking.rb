class File
  
  def File.open_locked(path, mode = "r", perm = 0644)
    File.open(path, mode, perm) do |file|
      begin
        file.flock(mode == "r" ? File::LOCK_SH : File::LOCK_EX)
        result = yield file
      ensure
        file.flock(File::LOCK_UN)
        return result
      end
    end
    []
  end
  
end