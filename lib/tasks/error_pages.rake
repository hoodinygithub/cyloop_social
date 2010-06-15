require 'yaml'
require 'iconv'

# # #
# Warning 
# In order to get this rake task running properly, you need to comment
# the protect_from_forgery call in application_controller
# # #

namespace :error_pages do
  desc "Clear all error pages"
  task :clear do
    paths = [
      File.join(RAILS_ROOT, "public", "500*.html"),
      File.join(RAILS_ROOT, "public", "404*.html"),
      File.join(RAILS_ROOT, "public", "422*.html"),
      File.join(RAILS_ROOT, "public", "400*.html"),
    ]
    
    paths.each {|p| system("rm -f #{p}")}
  end
  
  desc "Create static errors page from template"
  task :create do
    translate_keys_fp = File.join(RAILS_ROOT, 'config', 'locales', 'static.yml')
    sites_fp = File.join(RAILS_ROOT, 'config', 'sites.yml')
    content_keys = YAML::load_file(translate_keys_fp)['static']
    sites = YAML::load_file(sites_fp)
    
    content_keys.keys.each do |market|
      content_keys[market].keys.each do |error|
        file_fp = File.join(RAILS_ROOT, 'app', 'views', 'error_pages', 'blocks', "_p#{error}_#{market}.html.erb")
        if File.exist? file_fp
          title = content_keys[market][error]['page_title'] rescue ""
          partial = "p#{error}_#{market}"
          site_url = ""
          server = ENV['server'] || "http://localhost"
          port   = ENV['port']   || "3000"
          
          sites.each do |key, value|
            site_url = value['domains'].first if value['code'] == market
          end

          params = {
            :partial => partial,
            :site_url => site_url,
            :title => title
          }

          url = "#{server}:#{port}/pages/error_pages"
          puts "Requesting: #{url} with params: #{params.inspect}"
          
          res = Net::HTTP.post_form(URI.parse(url), params)
          if res.code == "200"
            new_market = case market
              when "msncaen"  then new_market = "_ca_en";
              when "msncafr"  then new_market = "_ca_fr";
              when "cyloop"   then new_market = "_cyloop";
              when "cyloopes" then new_market = "_es";
              when "tvn"      then new_market = "_tvn";
              when "widget"   then new_market = "_widget";
              else market.gsub("msn", "_");
            end

            target = File.join(RAILS_ROOT, 'public', "#{error}#{new_market}.html")
            File.open(target, "w") do |f|
              f.write(res.body)
            end
            puts "created!"
          else
            puts "error during creation"
          end
        end
      end
    end
  end
end
