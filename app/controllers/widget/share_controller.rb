
class Widget::ShareController < Widget::WidgetController

  def create
    sender_avatar = nil
    account_id = nil
    user_email = params[:user_email]
    sender_slug = nil
    sender_name = params[:user_name]

    if logged_in?
      sender_name = current_user.name
      sender_slug = current_user.slug
      account_id = current_user.id
      user_email ||= current_user.email
      sender_avatar = current_user.avatar_file_name
      unless sender_avatar.nil?
        sender_avatar = sender_avatar.sub('www', 'assets')
        unless sender_avatar.index('/.elhood.com').nil?
          sender_avatar = sender_avatar.sub(%r{/hires/}, '/thumbnail/')
          sender_avatar = sender_avatar
        else
          sender_avatar = File.join('system/avatars/', PartitionedPath.path_for(current_user.id), 'small', sender_avatar)
        end
      else
        if current_user.gender=='Male'
          sender_avatar = "avatars/missing/male.gif"
        else
          sender_avatar = "avatars/missing/female.gif"
        end
      end
    end

    recipients = params[:friend_email].split(',')
    recipients.map { |i| i.strip! }
    recipients.reject! { |i| i.blank? }
    unless params[:item_id].blank?
      @song = Song.find( params[:item_id] )
      params[:share_link] ||= "http://www.cyloop.com#{queue_song_path(:slug => @song.artist.slug, :id => @song.album, :song_id => @song)}"
      params[:item_title] ||= @song.title
      params[:item_author] ||= @song.artist.name
    end

    subject_line = t('share.song.subject', :user => sender_name)

    recipients.each do |email|
      UserNotification.send_share_song(
        :locale => current_site.default_locale,
        :mailto => email,
        :subject_line => subject_line,
        :sender => user_email,
        :sender_name => sender_name,
        :sender_avatar => sender_avatar,
        :sender_slug => sender_slug,
        :share_link => params[:share_link],
        :item_author => params[:item_author],
        :item_title => params[:item_title],
        :message => params[:message],
        :global_url => global_url)
    end

    SharedSong.create(
      :account_id => account_id,
      :sender_email => user_email,
      :recipient_email => params[:friend_email],
      :song_id => params[:item_id])

    respond_to do |format|
      format.xml { render :xml => Player::Message.new( :message => t('basics.message_sent') ) }
    end
  end

end