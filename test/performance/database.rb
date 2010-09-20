require 'rubygems'
require 'sequel'
require 'benchmark'

# Badass statistics math patched into Enumerable
# http://on-ruby.blogspot.com/2006/12/benchmarking-lies-and-statistics.html
module Enumerable
  # sum all the items
  def sum
    return self.inject(0) { |acc, i| acc + i }
  end
  
  # mean average of all the items
  def mean
    return self.sum / self.length.to_f
  end
  
  # variance of all the items
  def sample_variance
    avg = self.mean
    sum = self.inject(0) { |acc, i| acc + (i - avg) ** 2 }
    return (1 / self.length.to_f * sum)
  end
  
  # standard deviation of all the items
  def standard_deviation
    return Math.sqrt(self.sample_variance)
  end
end
### end Enumerable patch

yml = YAML::load(File.open('../../config/database.yml'))
DB = Sequel.connect(yml['development'])

# iterations help eliminate the effect of ordering: ruby init, garbage collection, etc.
# loops help the code reach a "steady-state" performance
# keep increasing these numbers until the results reach a steady-state

# hardcore settings
# iterations = 100
# loops = 100_000

iterations = 10
loops = 10_000
deltas = []

iterations.times do
  original_result = Benchmark.realtime do
    loops.times do
      # The old code goes here
      DB.fetch("select playlist_items.playlist_id from playlist_items
inner join playlists on playlists.id = playlist_items.playlist_id
inner join accounts on playlists.owner_id = accounts.id
where playlist_items.artist_id = #{rand(1687547)}
and playlists.deleted_at is null
and playlists.locked_at is null
and accounts.deleted_at is null
and accounts.network_id = 1
group by playlist_items.playlist_id
order by playlist_items.playlist_id DESC, playlists.updated_at DESC") {|row1|
        DB.fetch("SELECT * FROM playlists WHERE id = ? ORDER BY updated_at DESC", row1[:playlist_id]) {|row2| i = row2[:name]}
      }
      # end old code
    end
  end
  
  optimized_result = Benchmark.realtime do
    loops.times do
      # Your optimized code goes here.
      DB.fetch("select playlists.id from playlists
inner join playlist_items on playlist_items.playlist_id = playlists.id
inner join accounts on playlists.owner_id = accounts.id
inner join songs on songs.id = playlist_items.song_id
where playlist_items.artist_id = #{rand(1687547)}
and playlists.deleted_at is null
and playlists.locked_at is null
and accounts.deleted_at is null
and accounts.network_id = 1
and songs.deleted_at is null
group by playlist_items.playlist_id
order by playlists.updated_at DESC") {|row| i = row[:name]}
      # end optimized code
    end
  end
  deltas << (original_result - optimized_result)
end

deviation = deltas.standard_deviation
mean = deltas.mean
printf "standard deviation improvement: %fsecs\n", deviation
printf "mean improvement (secs): %fsecs\n", mean
max = mean + 2.0 * deviation
min = mean - 2.0 * deviation
if min <= 0 && 0 <= max
  # 0 is in the meat of the distribution
  puts "No statistically significant difference."
elsif mean > 0
  puts "Your optimization rules! \\m/"
else 
  puts "Back to work slacker."
end

#Benchmark.bm do |x|
#  x.report("old") do 
#    loops.times do
#    end
#  end  
#  
#  x.report("optimized") do
#    loops.times do
#    end
#  end
#end