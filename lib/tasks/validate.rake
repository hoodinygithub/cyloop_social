namespace :db do
  desc 'Validates referential integrity of cyloop developement'
  task :validate do
    cyloop_data_integrity_sql_file = File.join(Rails.root, 'db', 'cyloop_data_integrity.sql')
    mysql = `mysql cyloop_development < #{cyloop_data_integrity_sql_file}`
    puts mysql
    puts ''
  end
end
