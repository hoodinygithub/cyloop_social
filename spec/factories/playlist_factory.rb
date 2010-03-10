Factory.define :playlist do |factory|
  factory.name "80's Hits"
  factory.association :owner, :factory => :user
  factory.comments_count 0
  factory.total_time 300
end
