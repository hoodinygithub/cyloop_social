# == Schema Information
#
# Table name: login_types
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class LoginType < ActiveRecord::Base
  
end
