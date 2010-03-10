module Storage
  KEY = ["09d1003dcb320000bdb5f7bd14570ed612d5005de1d99b23"].pack("H*")

  def url
    "#{ENV['ASSETS_URL']}/storage/storage?fileName=" << Storage.encrypt("#{path}|#{id}|#{Storage.timestamp}|0|")
  end

  def self.encrypt(input)
    c = OpenSSL::Cipher::Cipher.new("DES-EDE3")
    c.key = KEY
    c.encrypt
    (c << input << c.final).unpack("H*").first.upcase!
  end

  def self.timestamp
    require 'open-uri'
    open("#{ENV['ASSETS_URL']}/storage/storageTimestamp").read
  end
end
