namespace :activity do
  desc "Prune activity store records for all users"
  task :prune => :environment do
    include Timebox
    
    DB = ActiveRecord::Base.connection
    limit = 100
    
    return if !DB.respond_to? :execute

    print "Activity pruning... " 
    timebox "Finished" do
      DB.execute 'TRUNCATE TABLE activity_pruning'
      users = DB.select_values "SELECT DISTINCT `account_id` FROM `activity_stores`"
      users.each do |account_id|
        DB.transaction do
          DB.execute 'TRUNCATE TABLE activity_pruning'
          DB.execute <<-EOF
            INSERT INTO `activity_pruning` 
            SELECT `id`, `created_at` FROM `activity_stores` WHERE `account_id` = #{account_id} 
          EOF
          DB.execute <<-EOF
            DELETE FROM `activity_pruning` ORDER BY `created_at` DESC LIMIT #{limit}
          EOF
          DB.execute <<-EOF
            DELETE `activity_stores` FROM `activity_stores` 
            INNER JOIN `activity_pruning` ON `activity_stores`.id = `activity_pruning`.id
          EOF
        end
      end
    end
  end
end