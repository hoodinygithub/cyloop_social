Factory.define :chat do |factory|
  factory.chat_date { Time.now + 2.days }
  factory.association :artist, :factory => :artist  
end
