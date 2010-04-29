module DashboardsHelper
  def nav_links(args = {})

    if args[:possessive] or page_owner?
      links = {
        :home     => my_dashboard_path,
        :stations => my_stations_path,
        :settings => my_settings_path,
        :activities => my_activities_path,
        :followers  => my_followers_path,
        :following  => my_following_index_path
        }
    else
      links = {
        :home     => user_path,
        :stations => user_stations_path,
        :settings => nil,
        :activities => activities_path,
        :followers  => followers_path,
        :following  => following_index_path
        }
    end

    items = if profile_artist?
      [{:menu => :home,          :label => "#{t('profile.navigation.home')}",             :url => links[:home]      },
       {:menu => :stations,      :label => "#{t('profile.navigation.stations')}",         :url => links[:stations]  },
       {:menu => :activity,      :label => "#{t('profile.navigation.activity')}",         :url => links[:activities]},
       {:menu => :followers,     :label => "#{t('profile.navigation.followers')}",        :url => links[:followers] },
       {:menu => :following,     :label => "#{t('profile.navigation.following')}",        :url => links[:following] }]
    else
      [{:menu => :home,          :label => "#{t('profile.navigation.home')}",             :url => links[:home]      },
       {:menu => :stations,      :label => "#{t('profile.navigation.stations')}",         :url => links[:stations]  },
       {:menu => :activity,      :label => "#{t('profile.navigation.activity')}",         :url => links[:activities]},
       {:menu => :followers,     :label => "#{t('profile.navigation.followers')}",        :url => links[:followers] },
       {:menu => :following,     :label => "#{t('profile.navigation.following')}",        :url => links[:following] }]
    end

    if links[:settings]
      items.push({:menu => :settings, :label => "#{t('profile.navigation.account_settings')}", :url => links[:settings]})
    end
    items
  end


  def user_top_navegation
    ul_list_to('links', 'current', true)
  end


  def user_sidebar_links
    ul_list_to('side_links', 'active')
  end

  def ul_list_to(ul_class, active_class, possessive=nil)
    items = []
    nav_links(:possessive => possessive).each do |item|
      link_classes = li_classes = ""
      link_classes = active_class if @dashboard_menu == item[:menu] and request.request_uri.match(/\/my\//)
      li_classes << "#{item[:menu]} "
      li_classes << 'last' if nav_links.last == item
      items << content_tag(:li, link_to(item[:label], item[:url], :class => link_classes), :class => li_classes)
    end
    content_tag(:ul, items.join("\n"), :class => ul_class)
  end
end

