# == Schema Information
#
# Table name: messages
#
#  id            :integer(4)      not null, primary key
#  chat_id       :integer(4)
#  question      :string(255)
#  location      :string(255)
#  name          :string(255)
#  user_id       :integer(4)
#  created_at    :datetime
#  updated_at    :datetime
#  status        :string(255)
#  pre_submitted :boolean(1)
#

class Message < ActiveRecord::Base
  belongs_to :chat
  belongs_to :user

  validates_presence_of :name, :location, :question, :chat_id

  named_scope :not_pending, :conditions => "status <> 'pending'", :order => "updated_at asc"
  
  before_validation :set_name_and_location  
  def set_name_and_location
    self.name = user.name if name.nil? || name.empty?
    self.location = user.city.location rescue user.country.name rescue nil if location.nil? || location.empty?
  end
  
  before_save :strip_html
  def strip_html # Automatically strips any tags from any string to text typed column
    for column in Message.content_columns
      if column.type == :string || column.type == :text # if the column is text-typed
        if !self[column.name].nil? # strip html from string if it's not empty
          self[column.name] = self[column.name].gsub(/<\/?[^>]*>/, "") 
        end
      end
    end
  end  

  include AASM

  aasm_column :status
  aasm_initial_state :pending
  aasm_state :pending
  aasm_state :approved
  aasm_state :answered

  aasm_event :approve do
    transitions :to => :approved, :from => [:pending]
  end

  aasm_event :unapprove do
    transitions :to => :pending, :from => [:approved]
  end

  aasm_event :mark_as_answered do
    transitions :to => :answered, :from => [:approved]
  end
end
