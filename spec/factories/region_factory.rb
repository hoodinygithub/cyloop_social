Factory.define :region do |factory|
  factory.name "Florida"
  factory.association :country
  #factory.country Country.first
  # factory.country do
  #   Country.find_or_create_by_name_and_code :name => "United States", :code =>"US"
  #  end
end
