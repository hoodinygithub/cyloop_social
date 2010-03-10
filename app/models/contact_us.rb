# == Schema Information
#
# Table name: tablelesses
#
#  category :string
#  address  :string
#  message  :string
#  os       :string
#  browser  :string
#  country  :string
#

class ContactUs < Tableless

  column :category, :string
  column :address, :string
  column :message, :string
  column :os, :string
  column :browser, :string
  column :country, :string
  
  validates_presence_of :category, :address, :message
  validates_format_of :address, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i

  
end



