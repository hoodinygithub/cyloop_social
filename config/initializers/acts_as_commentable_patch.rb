Comment.class_eval do

  extend ActionView::Helpers::SanitizeHelper::ClassMethods
  include ActionView::Helpers::SanitizeHelper

  validates_presence_of :comment
  validates_presence_of :rating

  validate :sanitize_comment

  def rating_cache
    self.rating
  end  

protected

  def self.valid(options = {})
    find_options = { 
      :joins => 'INNER JOIN playlists ON comments.commentable_id = playlists.id 
                 INNER JOIN accounts a1 ON playlists.owner_id = a1.id 
                 LEFT JOIN blocks ON blocks.blocker_id = playlists.owner_id and blockee_id = comments.user_id', 
      :conditions => 'playlists.deleted_at IS NULL AND a1.deleted_at IS NULL and blocks.blockee_id is null' }
    find_options.merge!(options)
      find(:all, find_options)
  end
    
  def sanitize_comment
    errors.add(:comment, I18n.t('share.errors.message.invalid_chars')) unless strip_tags(sanitize(comment)) == comment
  end

end
