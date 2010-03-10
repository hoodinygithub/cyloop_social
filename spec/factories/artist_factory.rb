Factory.define :artist do |factory|
  ActiveRecord::Base.connection.execute("TRUNCATE accounts")
  factory.name { "An Artist #{Time.now.to_f}" }
  factory.password "password"
  factory.websites "www.cyloop.com"
  factory.amg_id "P    34260"
  factory.password_confirmation {|a| a.password }
  factory.default_locale :en
  factory.email { "#{Time.now.to_f}@example.com" }
  factory.slug { Time.now.to_f.to_s.delete(".") }
  factory.status "registered"
  factory.songs_count 10
  factory.association :city, :factory => :city
  factory.association :genre, :factory => :genre
  factory.association :label, :factory => :label
end

Factory.define :top_artist do |factory|
  factory.total_listens 200
  factory.association :site, :factory => :site
  factory.association :artist, :factory => :artist
end

Factory.define :artist_without_station, :parent => :artist do |factory|
  factory.association :station, :factory => nil
end
