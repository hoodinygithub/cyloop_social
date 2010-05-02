class CampaignsController < ApplicationController
  layout "admin"
  before_filter :do_campaign_auth
  before_filter :load_campaign, :except => [:index, :new, :create]
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
    respond_to do |format|
      format.html { @campaign }
      format.xml  { render :xml => @campaign.attributes.merge!({"header-logo-file-path" => @campaign.header_logo_path}).to_xml(:root => "campaign") }
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
