require 'open-uri'
module BackgroundImporter
  def self.included(base)
    base.named_scope :pending_background_import, lambda {|*args| {:conditions => "#{base.table_name}.background_file_name IS NOT NULL AND #{base.table_name}.background_content_type IS NULL", :limit => args.first}}
  end

  def pending_background_url
    path = read_attribute(:background_file_name)
    if background_content_type.blank? && !path.blank?
       "#{ENV['ASSETS_URL']}/storage/storage?fileName=#{path}"
    end
  end
  def background_file_name
    begin
      pending_background_url || "/system/backgrounds/" + PartitionedPath.path_for(id).join("/") + "/original/" + read_attribute(:background_file_name) 
    rescue
    end
  end

  def import_background
    return unless pending_background_url
    #Rails.logger.info(URI.escape(pending_background_url))
    begin
      open(URI.escape(pending_background_url)) do |file|
        def file.original_filename
          File.basename(@base_uri.to_s)
        end
        self.background = file
        save_without_validation
      end
      background
    rescue OpenURI::HTTPError
      return
    end
  end
end
