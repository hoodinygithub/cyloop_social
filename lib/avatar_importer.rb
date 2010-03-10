require 'open-uri'
module AvatarImporter
  def self.included(base)
    base.named_scope :pending_avatar_import, lambda {|*args| {:conditions => "#{base.table_name}.avatar_file_name IS NOT NULL AND #{base.table_name}.avatar_content_type IS NULL", :limit => args.first}}
  end

  def pending_avatar_url
    path = read_attribute(:avatar_file_name)
    if avatar_content_type.blank? && !path.blank?
       "#{ENV['ASSETS_URL']}/storage?fileName=#{path}"
    end
  end
  def avatar_file_name
    pending_avatar_url || read_attribute(:avatar_file_name) 
  end
  
  def avatar_url_path
    path = read_attribute(:avatar_file_name)
    "/storage/storage?fileName=#{path}" || self.avatar.url
  end

  def import_avatar
    return unless pending_avatar_url
    #Rails.logger.info(URI.escape(pending_avatar_url))
    begin
      open(URI.escape(pending_avatar_url)) do |file|
        def file.original_filename
          File.basename(@base_uri.to_s)
        end
        self.avatar = file
        save_without_validation
      end
      avatar
    rescue OpenURI::HTTPError
      return
    end
  end
end
