namespace :sitemap do
  desc "Create sitemap XML file"
  task :create => :environment do
    total_statics = 1 # radio included
    total_artists = 0
    xml_output = ""
    xml = Builder::XmlMarkup.new(:target => xml_output, :indent => 2)

    xml.instruct! :"xml-stylesheet", :type=>"text/xsl", :href=>"sitemap_style.xsl"
    xml.urlset "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
               "xsi:schemaLocation" => "http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/siteindex.xsd",
               "xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9" do

      # Radio
      xml.url do
        xml.loc        "radio"
        xml.lastmod    Time.now.utc.strftime("%Y-%m-%dT%H:%M:%S+00:00")
        xml.changefreq "always"
        xml.priority   1.0
      end

      # Support Pages
      %w[support/cyloop support/terms_and_conditions support/privacy_policy support/safety_tips support/faq support/feedback].each do |url|
        xml.url do
          xml.loc        url
          xml.lastmod    Time.now.utc.strftime("%Y-%m-%dT%H:%M:%S+00:00")
          xml.changefreq "always"
          xml.priority   0.5
        end
        total_statics = total_statics + 1
      end

      # Artists
      Artist.all(:select => "name, slug", :order => "slug ASC").each do |artist|
        xml.url do
          xml.loc        "#{artist.slug}"
          xml.lastmod    Time.now.utc.strftime("%Y-%m-%dT%H:%M:%S+00:00")
          xml.changefreq "always"
          xml.priority   1.0
        end
        total_artists = total_artists + 1
      end
    end

    # Save file
    File.open(RAILS_ROOT + '/public/sitemap.xml', "w+") do |f|
      f.write(xml_output)
    end
    
    # print results
    puts "Indexed public pages......................[#{total_statics}]"
    puts "Indexed artists pages.....................[#{total_artists}]"
  end
end
