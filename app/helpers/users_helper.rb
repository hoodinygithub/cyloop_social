module UsersHelper

  def follow_button(user, options={})
    is_following    = options.fetch(:is_following, nil)
    skip_auto_width = options.fetch(:skip_auto_width, false)
    current_station = options.fetch(:current_station, session[:current_station])    
    
    if logged_in?
      id = user.kind_of?(Account) ? user.id : user      
      if is_following ||= current_user.follows?(id)
        unless is_following == true
          is_following.followee.private_profile??message = t("actions.awaiting_approval"): message = :unfollow
        else
          message = :unfollow
        end
        method = :post
      elsif current_user.awaiting_follow_approval?(id)
        message = t("actions.awaiting_approval")
        method = :post
      else
        message = :follow
        method = :put
      end
      right_follow_path = if skip_auto_width
        if method == :put
          special_followee_update_path(:id => id, :skip_auto_width => 1)
        else
          special_followee_destroy_path(:id => id, :skip_auto_width => 1)
        end          
      else
        if method == :put
          my_following_path(id)
        else
          followee_destroy_path(id)
        end
      end
      follow_button_element = button_to(
        message, 
        right_follow_path, 
        {
          :method          => method,
          :title           => message, 
          :class           => 'follow'
        }
      )
      content_tag(:div, follow_button_element)
    else
      user = Account.find(user) unless user.kind_of?(Account)
      id   = user.id      
      return_to = request.request_uri
      if return_to =~ /\/radio\/info\/([0-9]+)/
        station   = Artist.find($1).station rescue nil
        return_to = if station.nil?
          if current_station.nil?
            '/radio'
          else
            my_queue_my_station_path(current_station)
          end
        else
          my_queue_my_station_path(station)
        end
      end      
      layer_path = if user.kind_of?(User)
        follow_user_registration_layers_path(:return_to => return_to, :account_id => id, :follow_profile => id)
      else
        follow_artist_registration_layers_path(:return_to => return_to, :account_id => id, :follow_profile => id)
      end
      pill_link_to :follow, layer_path, :title => :follow, :class => "facebox follow"
    end
  end

  alias can_follow follow_button

  def possessive(object_key)
    if params[:slug]
      t("possessives.third_person.#{object_key.to_s}", :subject => profile_account.name)
    else
      t("possessives.first_person.#{object_key.to_s}")
    end
  end
end

