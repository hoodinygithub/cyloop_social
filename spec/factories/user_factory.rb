Factory.define :user do |factory|
  factory.name "A User"
  factory.password "password"
  factory.password_confirmation {|a| a.password }
  factory.email { "#{Time.now.to_f}@example.com" }
  factory.slug { Time.now.to_f.to_s.delete(".") }
  factory.twitter_username nil
  factory.twitter_id nil  #8541282

  factory.websites ["www.facebook.com"]
  factory.born_on Date.parse("1973-09-27")
  factory.short_bio "This is my bio"

  factory.gender "Male"
  factory.association :city, :factory => :city
  factory.entry_point_id do
    site = Site.first || Factory(:cyloop_site)
    site.id
  end
  
  factory.status "registered"
end

Factory.define :deleted_user, :parent => :user do |factory|
  factory.deleted_at { Time.now - 2.days }
  factory.name "Deleted User"
  factory.slug "deleted_user"
  factory.status "deleted"
  factory.twitter_username nil
end
