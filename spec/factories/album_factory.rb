Factory.define :album do |factory|
  factory.name "Album"
  factory.released_on "2007-07-23 20:24:04"
  factory.association :owner, :factory => :artist
  factory.total_time 300
  factory.songs_count 10
end
