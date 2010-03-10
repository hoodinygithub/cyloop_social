[ 'widget' ].each do |r|
  ActionController::Routing::Routes.add_configuration_file(File.join(RAILS_ROOT, 'config', 'routes', "#{r}_routes.rb" ))
end