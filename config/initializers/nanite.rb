# require 'nanite'
# require 'eventmachine'
# 
# if Rails.env.staging? || Rails.env.production? && !(ENV['SIMULATE_NANITE']=='true')
# 
#   Thread.abort_on_exception = true
# 
#   if File.basename( $0 ) == "worker"
#     Thread.new do
#       EM.run do
#         # Rails.logger.debug "STARTING NANITE MAPPER"
#         Nanite.start_mapper(
#           :identity => 'enzo',
#           :log_dir => 'log/nanite',
#           :log_level => 'debug',
#           :mapper => true,
#           :host => 'rabbit-server',
#           :user => 'mapper',
#           :pass => 'testing',
#           :vhost => '/nanite'
#         )
#         # Rails.logger.debug "NANITE MAPPER STARTED!"
#       end
#     end
#   end
# 
# end
