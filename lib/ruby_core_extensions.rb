require 'digest/md5'

class String
  def spaces_to_dashes
    self.gsub(' ', '-')
  end
  
  def firstcap
    self.gsub(/^(\w)/) { $1.chars.capitalize }  # /^([a-z])/
  end
end

class Hash
  def to_cache_key
    # in order to put this in memcached, we don't want the string to get too big
    Digest::MD5.hexdigest(self.map{|k,v| [k.to_s.spaces_to_dashes, v.to_s.spaces_to_dashes].join(':')}.join('/'))
  end
end
