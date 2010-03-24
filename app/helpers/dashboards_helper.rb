module DashboardsHelper
  def nav_links
    [
      {:menu => :home,          :label => "#{t('profile.navigation.home')}",             :url => my_dashboard_path },
#      {:menu => :mixes,         :label => "#{t('profile.navigation.mixes')}",            :url => '#' },
      {:menu => :stations,      :label => "#{t('profile.navigation.stations')}",         :url => my_stations_path },
      {:menu => :subscriptions, :label => "#{t('profile.navigation.subscriptions')}",    :url => '#' },
      {:menu => :reviews,       :label => "#{t('profile.navigation.reviews')}",          :url => '#' },
      {:menu => :activity,      :label => "#{t('profile.navigation.activity')}",         :url => activities_path },
      {:menu => :followers,     :label => "#{t('profile.navigation.followers')}",        :url => followers_path },
      {:menu => :following,     :label => "#{t('profile.navigation.following')}",        :url => following_index_path },
      {:menu => :settings ,     :label => "#{t('profile.navigation.account_settings')}", :url => my_settings_path }
    ]
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
