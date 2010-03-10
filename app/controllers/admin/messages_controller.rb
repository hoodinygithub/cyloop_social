class Admin::MessagesController < Admin::ApplicationController
  def moderator
    @chat=Chat.find(params[:id])
    @messages = @chat.messages
    render :layout => "chat"
  end

  def interviewee
    @chat=Chat.find(params[:id])
    @message = @chat.messages.first :conditions => ["status = 'approved'"], :order => "id asc"
    unless @message.blank?
      @n_messages=@chat.remaining_messages(@message.id, true)
    else
      @n_messages=0
    end
    render :layout => "chat"
  end

  def approve
    @message= Message.find(params[:message_id])
    @message.approve!
    respond_to do |format|
      # format.html is just for debugging purposes
      format.html { render :text => @message.to_json }
      format.json { render :json => @message.to_json }
    end
  end

  def unapprove
    @message= Message.find(params[:message_id])
    @message.unapprove!
    respond_to do |format|
      # format.html is just for debugging purposes
      format.html { render :text => @message.to_json }
      format.json { render :json => @message.to_json }
    end
  end

  def next
    @chat=Chat.find(params[:chat_id])
    @message = @chat.messages.first :conditions => ["status = 'approved' and id > #{params[:message_id]}"], :order => "id asc"
    more = {:number => @chat.remaining_messages(params[:message_id],true)}
    respond_to do |format|
      # format.html is just for debugging purposes
      format.html { render :text => @message.to_json }
      format.json { render :json => @message.to_json }
    end
  end

  def back
    @chat=Chat.find(params[:chat_id])
    @message = @chat.messages.first :conditions => ["status = 'approved' and id < #{params[:message_id]}"], :order => "id desc"

    respond_to do |format|
      # format.html is just for debugging purposes
      format.html { render :text => @message.to_json }
      format.json { render :json => @message.to_json }
    end
  end

  def more
    @chat=Chat.find(params[:chat_id])
    @n_messages=@chat.remaining_messages(params[:message_id])
    respond_to do |format|
      # format.html is just for debugging purposes
      format.html { render :text => @n_messages.to_json }
      format.json { render :json => @n_messages.to_json }
    end
  end

  def more_interviewee
    @chat=Chat.find(params[:chat_id])
    @n_messages=@chat.remaining_messages(params[:message_id], true)
    respond_to do |format|
      # format.html is just for debugging purposes
      format.html { render :text => @n_messages.to_json }
      format.json { render :json => @n_messages.to_json }
    end
  end




end

