namespace :db do
  namespace :populate do
    desc "Load newly ingested content."
    task :content => :environment do
      include Timebox
      
      rails_env = ENV["RAILS_ENV"]
      source_db = 'cyloop_migrations'
      dest_db = "cyloop_#{rails_env}"

      ENV["FIXTURES_PATH"] = "db/fixtures/ingestion"
    
      tables = ENV.has_key?('tables') ? ENV['tables'].split(/,/) : []
    
      cyloop_data_integrity_sql_file = File.join(Rails.root, 'db', 'cyloop_data_integrity.sql')
      base_dir = ENV['FIXTURES_PATH'] ? File.join(Rails.root, ENV['FIXTURES_PATH']) : File.join(Rails.root, 'test', 'fixtures','ingestion')
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
    
      timebox "Backing up tables..." do        
        Account.connection.execute "DROP TABLE IF EXISTS #{dest_db}._accounts_backup"
        Account.connection.execute "DROP TABLE IF EXISTS #{dest_db}._band_members_backup"
        Account.connection.execute "DROP TABLE IF EXISTS #{dest_db}._bios_backup"
        Account.connection.execute "DROP TABLE IF EXISTS #{dest_db}._albums_backup"
        Account.connection.execute "DROP TABLE IF EXISTS #{dest_db}._songs_backup"
        Account.connection.execute "DROP TABLE IF EXISTS #{dest_db}._song_genres_backup"
        
        #Backup accounts
        Account.connection.execute <<-EOF
        CREATE TABLE #{dest_db}._accounts_backup ENGINE=InnoDB
        SELECT * FROM #{dest_db}.accounts
        EOF
    
        #Backup band members
        Account.connection.execute <<-EOF
        CREATE TABLE #{dest_db}._band_members_backup ENGINE=InnoDB
        SELECT * FROM #{dest_db}.band_members
        EOF

        #Backup bios
        Account.connection.execute <<-EOF
        CREATE TABLE #{dest_db}._bios_backup
        SELECT * FROM #{dest_db}.bios
        EOF

        #Backup bios
        Account.connection.execute <<-EOF
        CREATE TABLE #{dest_db}._albums_backup
        SELECT * FROM #{dest_db}.albums
        EOF

        #Backup bios
        Account.connection.execute <<-EOF
        CREATE TABLE #{dest_db}._songs_backup
        SELECT * FROM #{dest_db}.songs
        EOF

        #Backup bios
        Account.connection.execute <<-EOF
        CREATE TABLE #{dest_db}._song_genres_backup
        SELECT * FROM #{dest_db}.song_genres
        EOF
        
      end
    
      
      source_connection = YAML.load(File.join(RAILS_ROOT, 'config/database.yml'),'r')['migrations'] 
      dest_connection = YAML.load(File.join(RAILS_ROOT, 'config/database.yml'),'r')[rails_env] 

      fixtures = fixtures_from_files if tables.empty?
      final_message = ENV.has_key?('validate') ? "Populate and validate complete" : "Populate complete"

      timebox(final_message) do  
        fixture_files.each do |fixture_file| 
          fixture_name = get_fixture_name(fixture_file)

          if(fixtures.include? fixture_name)
            table_name = fixture_name
            class_name = ActiveRecord::Base.pluralize_table_names ? table_name.singularize.camelize : table_name.camelizes
            klass = class_name.constantize
            klass.establish_connection source_connection        
      
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
          
            
            # timebox("#{table_name} AUTO_INCREMENT reset!") do
            #   puts "Resetting AUTO_INCREMENT..."
            #   connection.execute("ALTER TABLE #{quoted_table_name} MODIFY COLUMN #{quoted_primary_key} INT NOT NULL AUTO_INCREMENT")
            #   connection.execute("ALTER TABLE #{quoted_table_name} AUTO_INCREMENT=#{get_new_auto_increment_seed(rowcount)}") if rowcount > 0
            # end
    
            puts ''
          end
        end
        Rake::Task["db:validate"].invoke if ENV.has_key?('validate')
        
        timebox "Content ingestion complete..." do
          Account.establish_connection(dest_connection)
          Account.transaction do
            
            # timebox "Tables backups complete..." do
            #   original_create_statement = connection.select_one("SHOW CREATE TABLE #{quoted_table_name}")["Create Table"]
            #   #TODO: /AUTO_INCREMENT[^=]|AUTO_INCREMENT=\d+/
            #   fixed_create_statement = original_create_statement.sub(/AUTO_INCREMENT/i, '')
            # end
            
            timebox "Accounts updated..." do              
              #Update old accounts
              Account.connection.execute <<-EOF
              UPDATE #{dest_db}.accounts a1 
              INNER JOIN #{source_db}.accounts a2 ON a1.id = a2.id
              SET  a1.name = a2.name
                  ,a1.updated_at = now()
                  ,a1.gender = a2.gender
                  ,a1.born_on = a2.born_on
                  ,a1.avatar_file_name = a2.avatar_file_name
                  ,a1.avatar_content_type = NULL
                  ,a1.avatar_file_size = NULL
                  ,a1.avatar_updated_at = NULL
                  ,a1.amg_id = a2.amg_id
                  ,a1.color_header_bg = a2.color_header_bg
                  ,a1.color_main_font = a2.color_main_font
                  ,a1.color_links = a2.color_links
                  ,a1.color_bg = a2.color_bg
                  ,a1.private_profile = a2.private_profile
                  ,a1.cell_index = a2.cell_index
                  ,a1.background_file_name = a2.background_file_name
                  ,a1.background_content_type = NULL
                  ,a1.background_file_size = NULL
                  ,a1.background_updated_at = NULL
                  ,a1.background_align = a2.background_align
                  ,a1.background_repeat = a2.background_repeat
                  ,a1.background_fixed = a2.background_fixed
                  ,a1.deleted_at = a2.deleted_at
                  ,a1.genre_id = a2.genre_id
                  ,a1.default_locale = a2.default_locale
                  ,a1.label_id = a2.label_id
                  ,a1.influences = a2.influences
                  ,a1.label_type = a2.label_type
                  ,a1.management_email = a2.management_email
                  ,a1.music_label = a2.music_label
              EOF
              
              #Insert new accounts
              Account.connection.execute <<-EOF
              INSERT INTO #{dest_db}.accounts (
                       id
                      ,email
                      ,name
                      ,crypted_password
                      ,salt
                      ,created_at
                      ,gender
                      ,born_on
                      ,slug
                      ,type
                      ,avatar_file_name
                      ,avatar_content_type
                      ,avatar_file_size
                      ,avatar_updated_at
                      ,amg_id
                      ,city_id
                      ,entry_point_id
                      ,color_header_bg
                      ,color_main_font
                      ,color_links
                      ,color_bg
                      ,private_profile
                      ,cell_index
                      ,background_file_name
                      ,background_content_type
                      ,background_file_size
                      ,background_updated_at
                      ,background_align
                      ,background_repeat
                      ,background_fixed
                      ,deleted_at
                      ,created_by_id
                      ,status
                      ,genre_id
                      ,default_locale
                      ,label_id
                      ,influences
                      ,label_type
                      ,management_email                  
                      ,music_label
              ) 
              SELECT   a1.id
                      ,a1.email
                      ,a1.name
                      ,a1.crypted_password
                      ,a1.salt
                      ,a1.created_at
                      ,a1.gender
                      ,a1.born_on
                      ,a1.slug
                      ,a1.type
                      ,a1.avatar_file_name
                      ,a1.avatar_content_type
                      ,a1.avatar_file_size
                      ,a1.avatar_updated_at
                      ,a1.amg_id
                      ,a1.city_id
                      ,a1.entry_point_id
                      ,a1.color_header_bg
                      ,a1.color_main_font
                      ,a1.color_links
                      ,a1.color_bg
                      ,a1.private_profile
                      ,a1.cell_index
                      ,a1.background_file_name
                      ,a1.background_content_type
                      ,a1.background_file_size
                      ,a1.background_updated_at
                      ,a1.background_align
                      ,a1.background_repeat
                      ,a1.background_fixed
                      ,a1.deleted_at
                      ,a1.created_by_id
                      ,a1.status
                      ,a1.genre_id
                      ,a1.default_locale
                      ,a1.label_id
                      ,a1.influences
                      ,a1.label_type
                      ,a1.management_email
                      ,a1.music_label
              FROM #{source_db}.accounts a1
              LEFT JOIN #{dest_db}.accounts a2 ON a1.id = a2.id
              WHERE a2.id IS NULL
              EOF
            end
                
            timebox "Band Members updated..." do
              
              #Update old band members
              Account.connection.execute <<-EOF
              UPDATE #{dest_db}.band_members a1 
              INNER JOIN #{source_db}.band_members a2 ON a1.id = a2.id
              SET  a1.artist_id = a2.artist_id  
                  ,a1.name = a2.name
                  ,a1.instrument = a2.instrument
                  ,a1.bio = a2.bio
                  ,a1.updated_at = now()
              EOF

              #Insert new band members
              Account.connection.execute <<-EOF
              UPDATE #{dest_db}.band_members a1 
              INNER JOIN #{source_db}.band_members a2 ON a1.id = a2.id
              SET  a1.artist_id = a2.artist_id  
                  ,a1.name = a2.name
                  ,a1.instrument = a2.instrument
                  ,a1.bio = a2.bio
                  ,a1.updated_at = now()
              EOF


              Account.connection.execute <<-EOF
              INSERT INTO #{dest_db}.band_members (
                       id
                      ,artist_id
                      ,name
                      ,instrument
                      ,bio
                      ,created_at
              ) 
              SELECT   a1.id
                      ,a1.artist_id
                      ,a1.name
                      ,a1.instrument
                      ,a1.bio
                      ,a1.created_at                      
              FROM #{source_db}.band_members a1
              LEFT JOIN #{dest_db}.band_members a2 ON a1.id = a2.id
              WHERE a2.id IS NULL
              EOF
            end
                
            timebox "Bios updated..." do
              #Backup bios
              Account.connection.execute <<-EOF
              CREATE TABLE #{dest_db}._bios_backup
              SELECT * FROM #{dest_db}.bios
              EOF
              
              #Insert new bios
              Account.connection.execute <<-EOF
              INSERT INTO #{dest_db}.bios (
                       account_id
                      ,short
                      ,`long`
                      ,created_at
                      ,updated_at
                      ,locale
              ) 
              SELECT   a1.account_id
                      ,a1.short
                      ,a1.`long`
                      ,a1.created_at
                      ,a1.updated_at
                      ,a1.locale
              FROM #{source_db}.bios a1
              LEFT JOIN #{dest_db}.bios a2 ON a1.account_id = a2.account_id AND a1.locale = a2.locale 
              WHERE a2.account_id IS NULL AND a2.locale IS NULL
              EOF
            end

            timebox "Albums updated..." do
              #Backup albums
              Account.connection.execute <<-EOF
              CREATE TABLE #{dest_db}._albums_backup
              SELECT * FROM #{dest_db}.albums
              EOF
                            
              #Update old albums
              Account.connection.execute <<-EOF
              UPDATE #{dest_db}.albums a1 
              INNER JOIN #{source_db}.albums a2 ON a1.id = a2.id
              SET  a1.name = a2.name 
                  ,a1.owner_id = a2.owner_id
                  ,a1.songs_count = a2.songs_count
                  ,a1.year = a2.year
                  ,a1.upc = a2.upc
                  ,a1.avatar_file_name = a2.avatar_file_name
                  ,a1.avatar_content_type = a2.avatar_content_type
                  ,a1.avatar_file_size = a2.avatar_file_size
                  ,a1.avatar_updated_at = a2.avatar_updated_at
                  ,a1.updated_at = now()
                  ,a1.grid = a2.grid
                  ,a1.released_on = a2.released_on
                  ,a1.copyright = a2.copyright
                  ,a1.source = a2.source
                  ,a1.label_id = a2.label_id
                  ,a1.deleted_at = a2.deleted_at
                  ,a1.total_time = a2.total_time
              
              EOF

              #Insert new albums
              Account.connection.execute <<-EOF
              INSERT INTO #{dest_db}.albums (
                         id
                        ,name 
                        ,owner_id
                        ,songs_count
                        ,year
                        ,upc
                        ,avatar_file_name
                        ,avatar_content_type
                        ,avatar_file_size
                        ,avatar_updated_at
                        ,created_at
                        ,updated_at
                        ,grid
                        ,released_on
                        ,copyright
                        ,source
                        ,label_id
                        ,deleted_at
                        ,total_time
              ) 
              SELECT     a1.id
                        ,a1.name 
                        ,a1.owner_id
                        ,a1.songs_count
                        ,a1.year
                        ,a1.upc
                        ,a1.avatar_file_name
                        ,a1.avatar_content_type
                        ,a1.avatar_file_size
                        ,a1.avatar_updated_at
                        ,a1.created_at
                        ,a1.updated_at
                        ,a1.grid
                        ,a1.released_on
                        ,a1.copyright
                        ,a1.source
                        ,a1.label_id
                        ,a1.deleted_at
                        ,a1.total_time
              FROM #{source_db}.albums a1
              LEFT JOIN #{dest_db}.albums a2 ON a1.id = a2.id
              WHERE a2.id IS NULL
              EOF
            end

            timebox "Songs updated..." do
              #Backup songs
              Account.connection.execute <<-EOF
              CREATE TABLE #{dest_db}._songs_backup
              SELECT * FROM #{dest_db}.songs
              EOF
              
              #Update old songs
              Account.connection.execute <<-EOF
              UPDATE #{dest_db}.songs a1 
              INNER JOIN #{source_db}.songs a2 ON a1.id = a2.id
              SET  a1.title = a2.title
                  ,a1.artist_id = a2.artist_id
                  ,a1.updated_at = now()
                  ,a1.duration = a1.duration
                  ,a1.copyright = a2.copyright
                  ,a1.label = a2.label
                  ,a1.distributor = a2.distributor
                  ,a1.file_name = a2.file_name
                  ,a1.album_id = a2.album_id
                  ,a1.position = a2.position
                  ,a1.deleted_at = a2.deleted_at
                  ,a1.source = a2.source
              EOF

              #Insert new songs
              Account.connection.execute <<-EOF
              INSERT INTO #{dest_db}.songs (
                         id
                        ,title
                        ,artist_id
                        ,created_at
                        ,updated_at
                        ,duration
                        ,copyright
                        ,label
                        ,distributor
                        ,file_name
                        ,album_id
                        ,position
                        ,deleted_at
                        ,source
              ) 
              SELECT     a1.id
                        ,a1.title
                        ,a1.artist_id
                        ,a1.created_at
                        ,a1.duration
                        ,a1.copyright
                        ,a1.label
                        ,a1.distributor
                        ,a1.file_name
                        ,a1.album_id
                        ,a1.position
                        ,a1.deleted_at
                        ,a1.source
              FROM #{source_db}.songs a1
              LEFT JOIN #{dest_db}.songs a2 ON a1.id = a2.id
              WHERE a2.id IS NULL
              EOF
            end

            timebox "Song Genres updated..." do
              #Backup song genres
              Account.connection.execute <<-EOF
              CREATE TABLE #{dest_db}._song_genres_backup
              SELECT * FROM #{dest_db}.song_genres
              EOF

              #Update old songs
              Account.connection.execute <<-EOF
              TRUNCATE TABLE #{dest_db}.song_genres
              EOF

              #Insert new songs
              Account.connection.execute <<-EOF
              INSERT INTO #{dest_db}.song_genres
              SELECT     a1.id
                        ,a1.song_id
                        ,a1.genre_id
                        ,a1.created_at
                        ,a1.updated_at
              FROM #{source_db}.song_genres a1
              EOF
            end

            timebox "Song Listens - Albums remapped..." do
              #Backup song listens
              Account.connection.execute <<-EOF
              CREATE TABLE #{dest_db}._song_listens_backup
              SELECT * FROM #{dest_db}.song_listens
              EOF
              
              #Insert new songs
              Account.connection.execute <<-EOF
              UPDATE #{dest_db}.song_listens sl
              INNER JOIN  #{dest_db}.songs s ON sl.song_id = s.id
              SET sl.album_id = s.album_id
              EOF
            end
            puts ''
          end
        end 
      end #outer timebox
    end
    def get_fixture_name(path)
      File.basename(path, '.*') unless path.blank?
    end
  end
end
