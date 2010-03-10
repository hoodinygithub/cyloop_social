Given /^the following (.+)$/ do |model_name, table|
  factory_name = model_name.gsub(/\W+/, '_').singularize.to_sym
  table.hashes.each do |hash|
    if factory_name == :user
      User.destroy_all
      hash[:slug] += (Time.now.to_i * rand).to_i.to_s if hash[:slug]
      @user = Factory.create(:user, hash.symbolize_keys)
      Given 'the user is fully registered'
    else
      @artist = Factory.create(factory_name, hash.symbolize_keys)
      Factory.create(:bio, :account_id => @artist.id) if @artist.is_a?( Account )
    end
  end
end
