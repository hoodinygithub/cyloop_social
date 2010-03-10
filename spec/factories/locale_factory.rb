Factory.define :locale do |factory|
  factory.name "English (US)"
  factory.code "en_US"
  factory.country { Country.first }
  # factory.country do
  #   Country.find_or_create_by_name_and_code :name => "United States", :code =>"US"
  # end
  factory.supported true
end
