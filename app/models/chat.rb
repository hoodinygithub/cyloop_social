# == Schema Information
#
# Table name: chats
#
#  id         :integer(4)      not null, primary key
#  artist_id  :integer(4)
#  chat_date  :datetime
#  created_at :datetime
#  updated_at :datetime
#  markets    :string(255)
#  status     :string(255)
#  profile_id :integer(4)
#

class Chat < ActiveRecord::Base
  has_many :messages
  belongs_to :artist
  belongs_to :profile, :class_name => "Account"
  validates_presence_of :chat_date, :artist_id, :artist_slug, :profile_slug
  validate :profile_should_have_custom_profile_enabled

  serialize :markets

  def profile_should_have_custom_profile_enabled
    if !profile.nil? && !profile.has_custom_profile?
      self.errors.add(:profile_slug, "should have a custom profile defined")
    end
  end

  def artist_slug=(slug)
    self.artist = Artist.find_by_slug(slug)
  end

  def profile_slug=(slug)
    self.profile = Account.find_by_slug(slug)
  end

  def artist_slug
    artist.slug rescue nil
  end

  def profile_slug
    profile.slug rescue nil
  end

  include AASM

  aasm_column :status
  aasm_initial_state :disabled
  aasm_state :disabled
  aasm_state :promotion
  aasm_state :pre
  aasm_state :live
  aasm_state :ustream  
  aasm_state :finished
  aasm_state :post
  aasm_state :down

  aasm_event :promotion do
    transitions :to => :promotion, :from => [:disabled, :pre, :disabled]
  end

  aasm_event :pre do
    transitions :to => :pre, :from => [:promotion, :live, :disabled]
  end

  aasm_event :live do
    transitions :to => :live, :from => [:pre, :disabled, :down]
  end
  
  aasm_event :ustream do
    transitions :to => :ustream, :from => [:pre, :disabled, :down, :live]
  end  

  aasm_event :finish do
    transitions :to => :finished, :from => [:live, :disabled]
  end
  
  aasm_event :post do
    transitions :to => :post, :from => [:finished, :down]    
  end

  aasm_event :disable do
    transitions :to => :disabled, :from => [:promotion, :pre, :live, :finished, :post]
  end

  aasm_event :down do
    transitions :to => :down, :from => [:live, :pre]
  end

  def remaining_messages(last_id,approved=false)
      if approved
        conditions="status = 'approved' and id > #{last_id}"
      else
        conditions="id > #{last_id}"
      end
      more_messages = self.messages.count :conditions => [conditions], :order => "id asc"
      more_messages
  end

end

