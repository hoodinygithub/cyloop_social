module DashboardsHelper
  def nav_links
    items = []
    
    if page_owner?
      items.push({:menu => :home,          :label => "#{t('profile.navigation.home')}",             :url => my_dashboard_path })
      items.push({:menu => :stations,      :label => "#{t('profile.navigation.stations')}",         :url => my_stations_path })
      items.push({:menu => :settings ,     :label => "#{t('profile.navigation.account_settings')}", :url => my_settings_path })
    else
      items.push({:menu => :home,          :label => "#{t('profile.navigation.home')}",             :url => user_path })
      items.push({:menu => :stations,      :label => "#{t('profile.navigation.stations')}",         :url => user_stations_path })
    end
    
    items.push({:menu => :activity,      :label => "#{t('profile.navigation.activity')}",         :url => activities_path })
    items.push({:menu => :followers,     :label => "#{t('profile.navigation.followers')}",        :url => followers_path })
    items.push({:menu => :following,     :label => "#{t('profile.navigation.following')}",        :url => following_index_path })

    items
  end
  
  
  def user_top_navegation
    ul_list_to('links', 'current')
  end
  
  
  def user_sidebar_links
    ul_list_to('side_links', 'active')
  end
  
  def ul_list_to(ul_class, active_class)
    items = []
    nav_links.each do |item|
      link_classes = li_classes = ""
      link_classes = active_class if @dashboard_menu == item[:menu]
      li_classes = 'last' if nav_links.last == item
      items << content_tag(:li, link_to(item[:label], item[:url], :class => link_classes), :class => li_classes)
    end
    content_tag(:ul, items.join("\n"), :class => ul_class)
  end
end
