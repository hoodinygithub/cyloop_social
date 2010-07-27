class CampaignsController < ApplicationController
  layout "admin"
  before_filter :do_campaign_auth, :except => :campaign_key
  before_filter :load_campaign, :except => [:index, :new, :create, :campaign_key]
  before_filter :load_sites_and_player_information, :only => [:new, :create, :edit, :update]
  CAMPAIGNS_PER_PAGE = 50
  
  def index
    if params[:sort_order] and params[:sort_field]
      sort_conditions = "#{params[:sort_field]} #{params[:sort_order]}"
      @campaigns = Campaign.paginate :page => params[:page], :per_page => CAMPAIGNS_PER_PAGE, :order => sort_conditions
    else
      sort_conditions = "name ASC"
      @campaigns = Campaign.paginate :page => params[:page], :per_page => CAMPAIGNS_PER_PAGE, :order => sort_conditions
    end
  end
  
  def show
    return render :text => 'Campaign not active', :status => 405 unless @campaign.campaign_status.value == 'active'
    links ={}
    i = 1
    @campaign.campaign_links.each do |link|
      links["link#{i.to_s}-url"] = link.url
      links["link#{i.to_s}-name"] = link.name
      i += 1
    end
    links.merge!({"header-logo-file-path" => @campaign.header_logo.url, 
        "index-logo-file-path" => @campaign.index_logo.url, "footer-logo-file-path" => @campaign.footer_logo.url,
        "editorial-play-icon-file-path" => @campaign.editorial_play_icon.url})
    respond_to do |format|
      format.html { @campaign }
      format.xml  { render :xml => @campaign.attributes.merge!(links).to_xml(:root => "campaign")}
    end
  end

  def campaign_key
    player = Player.find_by_player_key(params[:player]);
    @campaign = player.active_campaign
    return render :text => 'Campaign not active', :status => 405 unless @campaign.campaign_status.value == 'active'
    respond_to do |format|
      format.xml  { render :xml => @campaign.attributes.merge!({"header-logo-file-path" => @campaign.header_logo.url}).to_xml(:root => "campaign") }
      format.js { render :json => @campaign }
    end
  end

  def campaign_key
    player = Player.find_by_player_key(params[:player]);
    @campaign = player.active_campaign
    return render :text => 'Campaign not active', :status => 405 unless @campaign.campaign_status.value == 'active'
    respond_to do |format|
      format.xml  { render :xml => @campaign.attributes.merge!({"header-logo-file-path" => @campaign.header_logo.url}).to_xml(:root => "campaign") }
      format.js { render :text => "var cssobj = #{@campaign.to_json}" }
      #format.js  { render :text => @campaign.attributes.merge!({"header-logo-file-path" => @campaign.header_logo.url}).map { |s| s } }
      #format.js  { render :text => @stations.collect{|s| "#{s.station.id}|#{s.name}|#{s.station_queue(:ip_address => remote_ip)}" }.join("\n") }
    end
  end
  
  def new
    @campaign = Campaign.new
  end
  
  def create
    @campaign = Campaign.new(params[:campaign])
    if @campaign.save
      flash[:success] = t('campaigns.saved')
      redirect_to campaigns_path
    else
      render :action => :new
    end
  end
  
  def edit
  end
  
  def update
    params[:campaign][:existing_link_attributes] ||= {}
    if @campaign.update_attributes(params[:campaign])
      flash[:success] = t('campaigns.updated_success')
      redirect_to campaigns_path
    else
      render :action => :edit
    end
  end
  
  def destroy
    if @campaign.destroy
      flash[:success] = t('campaigns.destroyed_success')
      redirect_to campaigns_path
    end
  end
  
  def activate
    if @campaign.update_attribute(:active, true)
      flash[:success] = t('campaigns.activated_success')
      redirect_to campaigns_path
    end
  end
  
  def deactivate
    if @campaign.update_attribute(:active, false)
      flash[:success] = t('campaigns.deactivated_success')
      redirect_to campaigns_path
    end
  end
  
  protected
  def load_campaign
    @campaign = Campaign.find(params[:id])
  end
  
  def load_sites_and_player_information
    @players = Player.all(:order => :player_key).collect {|p| [p.player_key, p.id]}
    @locales = I18n.valid_locales.map {|l| l.to_s}.collect {|ll| [ll, ll]}
    @statuses = CampaignStatus.all.collect {|status| [status.value.capitalize, status.id]}
  end
  
  def do_campaign_auth
    authenticate_or_request_with_http_basic do |username, password|
      username == "hoodiny" && password == "3057227000"
    end
  end
end
