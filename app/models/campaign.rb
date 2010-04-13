# == Schema Information
#
# Table name: campaigns
#
#  id                       :integer(4)      not null, primary key
#  name                     :string(255)
#  start                    :datetime
#  end                      :datetime
#  active                   :boolean(1)      default(FALSE)
#  hexcolor                 :string(255)
#  adcode                   :text
#  created_at               :datetime
#  updated_at               :datetime
#  site_id                  :integer(4)
#  player_id                :integer(4)
#  code                     :string(255)
#  notes                    :text
#  main_image_file_name     :string(255)
#  main_image_content_type  :string(255)
#  main_image_file_size     :integer(4)
#  main_image_updated_at    :datetime
#  footer_logo_file_name    :string(255)
#  footer_logo_content_type :string(255)
#  footer_logo_file_size    :integer(4)
#  footer_logo_updated_at   :datetime
#

class Campaign < ActiveRecord::Base
  ALLOWED_IMAGE_CONTENT_TYPES = ["image/jpeg", "image/png", "image/gif", "image/pjpeg", "image/x-png", "image/jpg"]
  
  belongs_to :site
  belongs_to :player
  
  validates_presence_of :name, :hexcolor, :adcode, :site_id, :player_id, :start, :end
  validate :date_range, :if => Proc.new {|c| c.start and c.end}
  
  has_attached_file :main_image, :styles => { :original => '600x600>', :small => "300x300#", :tiny => "30x30#"}
  validates_attachment_size :main_image, :less_than => 2.megabytes
  validates_attachment_content_type :main_image, :content_type => ALLOWED_IMAGE_CONTENT_TYPES

  has_attached_file :footer_logo, :styles => { :original => '600x600>', :small => "300x300#", :tiny => "30x30#"}
  validates_attachment_size :footer_logo, :less_than => 2.megabytes
  validates_attachment_content_type :footer_logo, :content_type => ALLOWED_IMAGE_CONTENT_TYPES
  
  private
  def date_range
    errors.add(:start, t('campaigns.start_date_gt_end_date')) if self.start >= self.end
  end
end
