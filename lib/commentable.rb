module Commentable
  def self.included(base)
    base.has_many :comments, :as => :commentable, :dependent => :destroy
  end
end
