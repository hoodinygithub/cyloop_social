class ChatsController < ApplicationController
  def justin_tv
    @chat = Chat.find(params[:id])
    render :partial => "chats/justin_tv", :layout => false
  end
end