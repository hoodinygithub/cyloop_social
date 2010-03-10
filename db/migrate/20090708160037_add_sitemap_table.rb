class AddSitemapTable < ActiveRecord::Migration
  def self.up
    create_table "sitemap_settings", :force => true do |t|
      t.string :name
      t.string :description
      t.string :xml_location
      t.string :username
      t.string :password
    
      t.timestamps
    end
    
    create_table "sitemap_static_links", :force => true do |t|
      t.string :url
      t.string :name
      t.float :priority
      t.string :frequency
      t.string :section
      
      t.timestamps
    end
    
    create_table "sitemap_widgets", :force => true do |t|
      t.string :widget_model
      t.string :index_named_route
      t.string :frequency_index
      t.string :frequency_show
      t.float :priority
      t.string :custom_finder
      
      t.timestamps
    end
    
    execute "INSERT INTO `sitemap_settings` (`id`,`name`,`description`,`xml_location`,`username`,`password`,`created_at`,`updated_at`) VALUES ('1','Cyloop','Cyloop','http://cyloop3.local/sitemap.xml','hoodiny','3057227000','2009-07-08 16:00:58','2009-07-08 17:11:35')"
    execute "INSERT INTO `sitemap_static_links` (`id`,`url`,`name`,`priority`,`frequency`,`section`,`created_at`,`updated_at`) VALUES ('1','about_url','About Cyloop','0.5','monthly','','2009-07-08 18:23:05','2009-07-08 18:26:10')"
    execute "INSERT INTO `sitemap_static_links` (`id`,`url`,`name`,`priority`,`frequency`,`section`,`created_at`,`updated_at`) VALUES ('2','terms_and_conditions_url','Terms and conditions','0.5','monthly','','2009-07-08 18:26:02','2009-07-08 18:49:42')"
    execute "INSERT INTO `sitemap_static_links` (`id`,`url`,`name`,`priority`,`frequency`,`section`,`created_at`,`updated_at`) VALUES ('3','privacy_policy_url','Privacy Policy','0.5','monthly','','2009-07-08 18:26:38','2009-07-08 18:49:36')"
    execute "INSERT INTO `sitemap_static_links` (`id`,`url`,`name`,`priority`,`frequency`,`section`,`created_at`,`updated_at`) VALUES ('4','safety_tips_url','Safety Tips','0.5','monthly','','2009-07-08 18:27:15','2009-07-08 18:49:28')"
    execute "INSERT INTO `sitemap_static_links` (`id`,`url`,`name`,`priority`,`frequency`,`section`,`created_at`,`updated_at`) VALUES ('5','faq_url','Frequently asked questions','0.5','monthly','','2009-07-08 18:27:59','2009-07-08 18:27:59')"
    execute "INSERT INTO `sitemap_static_links` (`id`,`url`,`name`,`priority`,`frequency`,`section`,`created_at`,`updated_at`) VALUES ('6','radio_url','Radio','1','always','','2009-07-08 18:48:37','2009-07-08 18:49:20')"
    # Removed cause of performance problems 
    # execute "INSERT INTO `sitemap_widgets` (`id`,`widget_model`,`index_named_route`,`frequency_index`,`frequency_show`,`priority`,`custom_finder`,`created_at`,`updated_at`) VALUES ('1','Artist','user_without_slug_path','always','always','1','ordered_by_slug','2009-07-08 17:17:50','2009-07-08 18:09:00')"    
  end

  def self.down
    drop_table "sitemap_settings"
    drop_table "sitemap_static_links"
    drop_table "sitemap_widgets"
  end
end
