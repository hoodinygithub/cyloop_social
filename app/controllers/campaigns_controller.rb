class CampaignsController < ApplicationController
  layout "admin"
  before_filter :do_basic_http_authentication
  before_filter :load_campaign, :except => [:index, :new, :create]
  before_filter :load_sites_and_player_information, :only => [:new, :create, :edit, :update]
  
  def index
    @campaigns = Campaign.all(:order => 'created_at')
  end
  
  def show
    respond_to do |format|
      format.html { @campaign }
      format.xml { render :xml => @campaign }
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
    @sites = Site.all(:order => :name).collect {|s| [s.name, s.id]}
    @players = Player.all(:order => :player_key).collect {|p| [p.player_key, p.id]}
  end
end
