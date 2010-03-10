namespace :image do
  desc 'Imports and Resizes profile, background and album images.'
  task :remake => [:import]
  
  task :import => :environment do
    user_type = ENV.has_key?('usertype') ? ENV['usertype='] : nil
    user_types = user_type.blank? ? ["User","Artist"] : [user_type]
    image_type = ENV.has_key?('imagetype') ? ENV['imagetype='] : nil
    image_types = image_type.blank? ? ["avatar","background"] : [image_type]
    base_dir = File.join(Rails.root, "app/models")
    
    final_message = !user_type.blank? ? "Importing images for " + user_type.pluralize : "Importing images for Users and Artists"
    
    timebox(final_message) do 
      user_types.each do |type|
        klass = type.classify.constantize
        klass.all.each do |account|
          image_types.each do |itype|
            account.send("import_#{itype}".to_sym)
          end
          puts 'Account:' + account.name
        end
      end
    end
  end
  
  def timebox(message, &block)
    start_time = Time.now
    yield
    end_time = Time.now
    puts(message + " " + (end_time - start_time).to_s + " seconds")
  end
  
end
