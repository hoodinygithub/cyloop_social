class Admin::ChatsController < Admin::ApplicationController
  before_filter :find_chat, :except => [:index, :new, :create]
  
  def index
    @chats = Chat.paginate :page => params[:page], :per_page => 15 , :order=> "id DESC"
  end
  
  def new
    @chat = Chat.new(params[:chat])
  end
  
  def create
    @chat = Chat.new(params[:chat])
    if @chat.save
      flash[:notice] = "Chat created"      
      redirect_to admin_chats_path
    else
      render :new
    end    
  end
  
  def edit
    render :new
  end
  
  def update
    if @chat.update_attributes(params[:chat])
      flash[:notice] = "Chat updated"
      redirect_to admin_chats_path      
    else
      render :new      
    end
  end
  
  def confirm_remove
  end
  
  def destroy
    @chat.destroy
    redirect_to admin_chats_path
  end
  
  def messages
    @messages = @chat.messages.find :all, :conditions => ["id > ?", params[:message_id]]
    respond_to do |format|
      format.json { render :json => @messages.collect{|m| {:id => m.id, :name => m.name, :location => m.location, :question => m.question} }.to_json }
    end
  end  
private
  def find_chat
    @chat = Chat.find(params[:id])
  end
end

