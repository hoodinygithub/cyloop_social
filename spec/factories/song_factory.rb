Factory.define :song do |factory|
  ActiveRecord::Base.connection.execute("TRUNCATE songs")
  factory.association :artist
  factory.association :album
  factory.position rand(100)
  factory.title do
    ["Echoes", "Time", "Money", "Shine On You Crazy Diamond", "Sheep", "Pigs", "Dogs"].rand
  end
end
