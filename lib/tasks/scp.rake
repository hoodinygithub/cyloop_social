HOSTS = {
  'ey06-brp1' => 'brazil',
  'ey06-mxp1' => 'mexico',
  'ey06-latam1' => 'latam',
  'ey06-latino1' => 'latino',
  'ey06-can1' => 'canada_en',
  'ey06-can2' => 'canada_fr'
}
namespace :scp do
  task :beanstalk_yml do
    HOSTS.keys.each do |host|
      puts "copying #{host}: #{HOSTS[host]}"
      system("scp config/beanstalk.yml #{host}:/data/#{HOSTS[host]}/current/config")
    end
  end

  task :memcached_expiration_times_yml do
    HOSTS.keys.each do |host|
      puts "copying #{host}: #{HOSTS[host]}"
      system("scp config/memcached_expiration_times.yml #{host}:/data/#{HOSTS[host]}/current/config/memcached_expiration_times.yml")
    end
  end
  
  task :memcached_yml do
    system("scp config/memcached.yml #{eyhost}:/shared/common/config")
  end
end