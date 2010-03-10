# Allow the metal piece to run in isolation
require(File.dirname(__FILE__) + "/../../config/environment") unless defined?(Rails)

class Customizations
  def self.call(env)
    if env["PATH_INFO"] =~ /^\/profiles\/(\w+)\/customizations.css$/
      slug = $1
      # css = Rails.cache.fetch("profiles/#{slug}/customizations") do
      #   account = Account.find_by_slug(slug)
      #   account.write_customizations
      # end
      css = Rails.cache.fetch("profiles/#{slug.gsub(' ', '-')}/customizations") do
        CustomizationWriter.new(Account.find_by_slug(slug)).prepare_template
      end      
      [200, {"Content-Type" => "text/css", "Cache-Control" => "no-cache", "Expires" => "-1"}, [css]]
    else
      [404, {"Content-Type" => "text/html"}, ["Not Found"]]
    end
  end
end
