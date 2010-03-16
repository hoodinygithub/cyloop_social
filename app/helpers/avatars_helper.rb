module AvatarsHelper

  def avatar_for(target, type = :medium, options = {})
    avatar = target.try(:avatar)
    path = AvatarsHelper.avatar_path( target, type )

    if avatar
      if options.size > 0 
        options[:class] = "avatar #{type}"
        options[:title] = options[:alt] unless !options.has_key?(:alt)
        image_tag path, options
      else
        image_tag path, :alt => avatar.instance.to_s, :title => avatar.instance.to_s, :class => "avatar #{type} follower_image"
      end
    else
      image_tag path, :class => "avatar #{type}"
    end

  end

  def avatar_for_activity(path, user_id, gender, options = {}, type = :medium)
    # Moved from views
    path = "#{path}".sub("www", "assets")    
    
    if !path.nil? && !path.empty?
      if !path.index("/.elhood.com").nil?
        path = path.sub(%r{/hires/}, '/hi-thumbnail/') if type == :new_medium
        path = path.sub(%r{/hires/}, '/hi-thumbnail/') if type == :medium
        path = path.sub(%r{/hires/}, '/thumbnail/') unless type == :album
        path = ("#{ENV['ASSETS_URL']}/storage/storage?fileName=" + path) unless (path.index("http://")==0)
      elsif path =~ /\/avatars\/missing\/.*gif/
        path = path
      else
        path = File.join("/system/avatars/", PartitionedPath.path_for(user_id), "small", path)
      end
    else
      path = "/avatars/missing/missing.png"
    end
    
    if path =~ /^\/avatars\/(.*)\/missing.png$/
      path = '/avatars/missing/artist.gif'
    end
    
    path = path.sub('www','assets')
    if options.size > 0
      options[:class] = "avatar #{type}"
      options[:title] = options[:alt] unless !options.has_key?(:alt)
      image_tag path, options
    else
      image_tag path, :class => "avatar #{type}"
    end
  end

  class << self

    def avatar_path( target, type )
      avatar = target.try(:avatar)
      if avatar
        if path = avatar.instance.try(:pending_avatar_url)
          path = path.sub(%r{/hires/}, '/hi-thumbnail/') if type == :medium
          path = path.sub(%r{/hires/}, '/hi-thumbnail/') if type == :new_medium
          path = path.sub(%r{/hires/}, '/thumbnail/') unless type == :album
          path = path.sub(%r{/hires/}, '/thumbnail/') if type == :small
          path = path.sub(%r{/hires/}, '/thumbnail/') if type == :artist_icon
          path = path.sub(%r{/hires/}, '/comments/') if type == :album
        else
          path = avatar.url(type)
        end
      else
        path = "/avatars/missing/missing.png"
      end

      if path =~ /^\/avatars\/(.*)\/missing.png$/
        if target
          if target.is_a?(User) || target.is_a?(Playlist)
            if target.gender =~ /^male$/i
              path = '/avatars/missing/male.gif'
            else
              path = '/avatars/missing/female.gif'
            end
          else
            path = '/avatars/missing/artist.gif'
          end
        else
          path = '/avatars/missing/artist.gif'
        end
      end

      path
    end

  end


end
