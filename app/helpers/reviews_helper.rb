module ReviewsHelper
  
  def reviews_actions_for(review)
    view_more = "<a href=\"#\" onclick=\"Base.reviews.show(#{review.id}); return false;\">
                   #{t('actions.view_more')}
                 </a>" if review.comment.size > 90

    edit = "<a href=\"#\" onclick=\"Base.reviews.edit(#{review.id}, true); return false;\">
              #{t('actions.edit')}
            </a>" if review.user == current_user

    actions = [view_more, edit].compact.join('|')
  end

end
