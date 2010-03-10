ActionController::Routing::Routes.draw do |map|
  map.namespace :widget do |widget|
    widget.resources :stations, :collection => { :top => :get }, :only => [ :create, :index ]
    widget.resources :song_buylinks, :only => :show
    widget.resource  :share, :controller => 'share', :only => :create
    widget.resources :user_stations, :only => [ :index, :destroy, :update ]
    widget.resources :sites_stations, :only => :index
    widget.resources :translations, :only => :index
    widget.resource :session, :only => :create
    widget.resources :users, :only => [ :create, :status ]
  end
end
