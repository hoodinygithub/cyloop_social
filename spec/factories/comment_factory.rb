Factory.define :comment do |factory|
  factory.association :owner, :factory => :user
  factory.association :commentable, :factory => :user
  factory.body "Hi"
end
