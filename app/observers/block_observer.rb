class BlockObserver < ActiveRecord::Observer
  # observe :block
  # 
  # def after_create(block)
  #   block.blocker.followees.delete(block.blockee) # have current user stop following target
  #   block.blockee.followees.delete(block.blocker) # have target stop following current user
  # end
end