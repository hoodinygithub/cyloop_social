class MessagesController < ApplicationController
  def index
    @chat     = Chat.find(params[:chat_id])
    respond_to do |format|
      format.json do
        @messages = @chat.messages.find :all, :conditions => ["id > ? and status IN (?)", params[:message_id], ['answered', 'approved']]
        render :json => @messages.collect{|m| {:id => m.id, :name => m.name, :location => m.location, :question => m.question} }.to_json
      end
      format.js do
        @messages = @chat.messages.find :all, :conditions => ["status IN (?)", ['answered', 'approved']]
        if @messages && @messages.size != params[:total_questions].to_i
          render :update do |page|
            page.replace_html "questions_body", :partial => "custom_profiles/chat_questions"
            if @chat.down? && params[:justin_tv].to_i > 0
              page.replace_html "livestream_frame", :partial => "custom_profiles/chat_down"
            elsif @chat.live? && params[:justin_tv].to_i == 0
              page.replace_html "livestream_frame", :partial => "chats/justin_tv"
            elsif @chat.ustream? && params[:ustream].to_i == 0
              page.replace_html "livestream_frame", :partial => "chats/ustream"
            elsif @chat.finished?
              page.replace_html "livestream_frame", ""
              page.replace_html "chat_form", :partial => "custom_profiles/#{@chat.artist.slug}_chat_ended"
              page << "$(\"#questions\").stopTime();"
            end
          end
        end
      end
    end
  end

  def new
    @message = current_user.messages.build
  end

  def create
    # TODO: Add keys for default values on fields
    if params[:message]
      params[:message][:question] = nil if params[:message][:question] == "Escribe tu pregunta aquí"
      params[:message][:name]     = nil if params[:message][:name] == "¿Cómo te llamas?"
      params[:message][:location] = nil if params[:message][:location] == "¿De dónde eres?"
    end
    @message = current_user.messages.build(params[:message])
    respond_to do |format|
      if @message.save
        format.js
      else
        @errors = @message.errors.collect do |e|
          attribute = I18n.t("activerecord.attributes.message.#{e.first}")
          "#{attribute} #{e.last}"
        end
        format.js
      end
    end
  end
end

