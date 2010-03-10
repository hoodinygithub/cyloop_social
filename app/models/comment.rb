# == Schema Information
#
# Table name: comments
#
#  id               :integer(4)      not null, primary key
#  owner_id         :integer(4)
#  commentable_type :string(255)
#  commentable_id   :integer(4)
#  body             :text
#  created_at       :datetime
#  updated_at       :datetime
#

class Comment < ActiveRecord::Base
  belongs_to :owner, :class_name => 'User'
  belongs_to :commentable, :polymorphic => true

  validates_presence_of :owner, :commentable, :body
  validates_length_of :body, :maximum => 3000, :allow_blank => true
end
