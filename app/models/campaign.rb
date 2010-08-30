class Campaign < ActiveRecord::Base
  after_update :save_links
  ALLOWED_IMAGE_CONTENT_TYPES = ["image/jpeg", "image/png", "image/gif", "image/pjpeg", "image/x-png", "image/jpg"]

  belongs_to :player
  belongs_to :campaign_status

  has_many :campaign_links

  validates_presence_of :name, :hexcolor, :player_id, :start, :end
  validate :date_range, :if => Proc.new {|c| c.start and c.end}
  validate :unique_player_id_per_active_campaign

  named_scope :active, :conditions => { :campaign_status_id => 2 }

  has_attached_file :header_logo, :styles => { :original => '950x40>', :thumb => '80x80>' }
  validates_attachment_size :header_logo, :less_than => 2.megabytes
  validates_attachment_content_type :header_logo, :content_type => ALLOWED_IMAGE_CONTENT_TYPES

  has_attached_file :index_logo, :styles => { :original => '500x500>', :thumb => '80x80>' }
  validates_attachment_size :index_logo, :less_than => 2.megabytes
  validates_attachment_content_type :index_logo, :content_type => ALLOWED_IMAGE_CONTENT_TYPES

  has_attached_file :footer_logo, :styles => { :original => '500x500>', :thumb => '80x80>' }
  validates_attachment_size :footer_logo, :less_than => 2.megabytes
  validates_attachment_content_type :footer_logo, :content_type => ALLOWED_IMAGE_CONTENT_TYPES

  has_attached_file :editorial_play_icon, :styles => { :original => '500x500>', :thumb => '80x80>' }
  validates_attachment_size :editorial_play_icon, :less_than => 2.megabytes
  validates_attachment_content_type :editorial_play_icon, :content_type => ALLOWED_IMAGE_CONTENT_TYPES

  has_attached_file :campaign_background, :styles => { :original => '2000x1122>', :thumb => '80x80>' }
  validates_attachment_size :campaign_background , :less_than => 2.megabytes
  validates_attachment_content_type :campaign_background, :content_type => ALLOWED_IMAGE_CONTENT_TYPES

  def header_logo_url
    self.header_logo.url[1, self.header_logo.url.size] rescue ""
  end

  def footer_logo_url
    self.footer_logo.url[1, self.footer_logo.url.size] rescue ""
  end

  def header_logo_dimensions
    if self.header_logo.file?
      Paperclip::Geometry.from_file(self.header_logo.path) rescue '0x0'
    else
      '0x0'
    end
  end

  def index_logo_dimensions
    if self.index_logo.file?
      Paperclip::Geometry.from_file(self.index_logo.path) rescue '0x0'
    else
      '0x0'
    end
  end

  def footer_logo_dimensions
    if self.footer_logo.file?
      Paperclip::Geometry.from_file(self.footer_logo.path) rescue '0x0'
    else
      '0x0'
    end
  end

  def editorial_play_icon_dimensions
    if self.editorial_play_icon.file?
      Paperclip::Geometry.from_file(self.editorial_play_icon.path) rescue '0x0'
    else
      '0x0'
    end
  end
  
  def campaign_background_dimensions
    if self.campaign_background.file?
      Paperclip::Geometry.from_file(self.campaign_background.path) rescue '0x0'
    else
      '0x0'
    end
  end

  def new_link_attributes=(link_attributes)
    link_attributes.each do |attributes|
      campaign_links.build(attributes)
    end
  end

  def existing_link_attributes=(link_attributes)
    campaign_links.reject(&:new_record?).each do |link|
      attributes = link_attributes[link.id.to_s]
      if attributes
        link.attributes = attributes
      else
        campaign_links.delete(link)
      end
    end
  end

  def save_links
    campaign_links.each do |link|
      link.save(false)
    end
  end

  private
  def unique_player_id_per_active_campaign
    campaigns_using_player = Campaign.all(:conditions => ['player_id = ? AND id <> ?', self.player_id, self.id], :include => :campaign_status)
    statuses = campaigns_using_player.collect {|c| c.campaign_status.value == 'active'}.delete_if {|cc| !cc}
    if self.campaign_status and self.campaign_status.value == 'active' and statuses.size > 0
      errors.add(:player_id, I18n.t('campaigns.duplicated_active_campaigns_per_player'))
    end
  end

  def date_range
    errors.add(:start, I18n.t('campaigns.start_date_gt_end_date')) if self.start >= self.end
  end

end
