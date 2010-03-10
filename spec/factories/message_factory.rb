Factory.define :message do |factory|
  factory.name "John Doe"
  factory.question "What's your name?"
  factory.city "Wonderland, NL"
  factory.association :chat, :factory => :chat
end
