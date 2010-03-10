namespace :db do
  namespace :populate do
    task :default => [:populate_db]
    
    task :all => [:populate_db, :profile_stats, :summaries] do
      puts "populating all sample data"
    end
    
    desc "Load sample data"
    task :populate_db => :environment do
      include Timebox

      ENV["FIXTURES_PATH"] = "db/fixtures"

      tables = ENV.has_key?('tables') ? ENV['tables'].split(/,/) : []

      cyloop_data_integrity_sql_file = File.join(Rails.root, 'db', 'cyloop_data_integrity.sql')
      base_dir = ENV['FIXTURES_PATH'] ? File.join(Rails.root, ENV['FIXTURES_PATH']) : File.join(Rails.root, 'test', 'fixtures')
      fixtures_dir = ENV['FIXTURES_DIR'] ? File.join(base_dir, ENV['FIXTURES_DIR']) : base_dir

      fixture_files = (ENV['FIXTURES'] ? ENV['FIXTURES'].split(/,/).map {|f| File.join(fixtures_dir, f) } : Dir.glob(File.join(fixtures_dir, '*.{yml,csv}')))
      fixtures_from_files = fixture_files.collect { |f| get_fixture_name(f) }

      if ENV.has_key?('exclude') 
        if(ENV["exclude"]=="true")
          fixtures = fixtures_from_files - tables 
        else      
          fixtures = fixtures_from_files & tables
        end      
      else      
        fixtures = fixtures_from_files & tables
      end

      raise "No matched fixtures were found" if fixtures.empty? && !tables.empty?

      fixtures = fixtures_from_files if tables.empty?
      final_message = ENV.has_key?('validate') ? "Populate and validate complete" : "Populate complete"

      timebox(final_message) do  
        fixture_files.each do |fixture_file| 
          fixture_name = get_fixture_name(fixture_file)

          if(fixtures.include? fixture_name)
            table_name = fixture_name
            class_name = ActiveRecord::Base.pluralize_table_names ? table_name.singularize.camelize : table_name.camelizes
            klass = class_name.constantize
            connection = klass.connection if klass.respond_to?(:connection)
            quoted_table_name = connection.quote_table_name(table_name) unless table_name.blank?
            quoted_primary_key = connection.quote_column_name(klass.primary_key) unless klass.primary_key.blank?

            original_create_statement = connection.select_one("SHOW CREATE TABLE #{quoted_table_name}")["Create Table"]
            #TODO: /AUTO_INCREMENT[^=]|AUTO_INCREMENT=\d+/
            fixed_create_statement = original_create_statement.sub(/AUTO_INCREMENT/i, '')

            headers = `head -n 1 "#{fixture_file}"`.sub(/\n/,"").split(',').collect{ |field| connection.quote_column_name(field) }
            rowcount = 0

            puts "Preparing #{table_name}..."
            timebox("#{table_name} dropped!") do
              connection.execute("DROP TABLE #{table_name}")
            end

            timebox("#{table_name} recreated!") do
              connection.execute(fixed_create_statement)
            end

            timebox("#{table_name} loaded!") do
              puts "Loading data..."
              connection.execute("LOAD DATA LOCAL INFILE '#{fixture_file}' INTO TABLE #{quoted_table_name} FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"' LINES TERMINATED BY '\\n' (#{headers.join(',')})")
              connection.execute("DELETE FROM #{quoted_table_name} WHERE #{quoted_primary_key} = 0")
              rowcount = connection.select_one("SELECT count(*) as result FROM #{quoted_table_name}")["result"].to_i
              puts "#{rowcount} rows inserted"
            end

            timebox("#{table_name} AUTO_INCREMENT reset!") do
              puts "Resetting AUTO_INCREMENT..."
              connection.execute("ALTER TABLE #{quoted_table_name} MODIFY COLUMN #{quoted_primary_key} INT NOT NULL AUTO_INCREMENT")
              connection.execute("ALTER TABLE #{quoted_table_name} AUTO_INCREMENT=#{get_new_auto_increment_seed(rowcount)}") if rowcount > 0
            end

            puts ''
          end
        end
        Rake::Task["db:validate"].invoke if ENV.has_key?('validate')
        Rake::Task["db:populate:summaries"].invoke
      end #outer timebox
    end
    
    desc "Populate NewActivityStore from Activity Store"
    task :activity => :environment do
      include Timebox
      
      last_id = ENV.has_key?('id') ? ENV['id='] : nil
      activity_array = []

      if(last_id.nil?)
        timebox("Dropping all records from NewActivityStore") do
          NewActivityStore.delete_all
        end
        activity_array = ActivityStore.find(:all, :order => "id desc")
      else
        activity_array = ActivityStore.find(:all, :conditions => "id < #{last_id}", :order => "id desc")
      end

      timebox("Running through each record in ActivityStore") do
        activity_array.each do |item|
          begin
            raw_data = JSON.parse(item.data)
            activity = JSON.parse(raw_data['activity'])
            activity_type = activity['type']
            owners_record = (item.account_id == activity['user']['id'])

            NewActivityStore.create!(:account_id => item.account_id, :data => item.data, :activity_type => activity_type, :mine => owners_record)
            puts "Moved Activity with ID: #{item.id}"
          rescue
            puts "** ERROR on ID: #{item.id}"
          end
        end
      end
    end
    
    desc "Populate Login Types"
    task :login_types => :environment do
      include Timebox
      
      types_array = ["cyloop","wlid_web","wlid_delegated"]
      
      if LoginType.all.empty?
        timebox("Adding Login Types to DB") do
          types_array.each do |l|
            begin
              LoginType.create!(:name => l)
            rescue
              puts "** ERROR on Login Type: #{l}"
            end
          end
        end
      end
      
      timebox("Adding Login Type to Site") do
        Site.all.each do |site|
          if(site.name.include? "MSN")
            site.update_attribute(:login_type_id, LoginType.find_by_name("wlid_web").id)
          else
            site.update_attribute(:login_type_id, LoginType.find_by_name("cyloop").id)
          end
        end
      end
    end

    def get_fixture_name(path)
      File.basename(path, '.*') unless path.blank?
    end

    def get_new_auto_increment_seed(seed)
      threshold = 0.25
      new_size = 10**seed.to_s.size
      new_size = new_size * 1.5 if new_size - seed <= new_size * threshold
      new_size.to_i
    end
  end
end