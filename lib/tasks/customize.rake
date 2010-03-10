namespace :customizations do
  desc "Regenerate user customizations"
  task :regenerate => :environment do
    # done = 0
    # errors = 0
    # Account.paginated_each(:per_page => 100, :conditions => ) do |user|
    #   begin
    #     user.write_customizations 
    #     done += 1
    #   rescue
    #     errors += 1
    #     puts "Error in #{u.inspect}"
    #     next
    #   end
    # end
    # 
    # puts "Regenerated #{done} user customizations, #{errors} errors"
    klass = (ENV.has_key? 'klass') ? ENV['klass'].classify.constantize : Account rescue Account

    if [Account, Artist, User].include?(klass)  
      puts "Running batches for class #{klass.class}"
      batch = BolingForBatches::Batch.new(:klass => klass, :batch_size => 50, :order => 'id')
      batch.run(:write_customizations)
      batch.print_results
    end
  end
end