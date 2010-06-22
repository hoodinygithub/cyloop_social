
class Widget::SessionsController < Widget::WidgetController

  def create
    account = Account.authenticate(params[:email], params[:password], current_site)
    if account && account.kind_of?( User )
      self.current_user = account
      AccountLogin.create!( :account_id => current_user.id, :site_id => current_site.id )
      respond_to do |format|
        format.xml do
          render :xml => Player::Message.new( :message => t('widget.login.success') )
        end
      end
    else
      respond_to do |format|
        format.xml do
          render :xml => Player::Error.new( :error => t('registration.login_failed'), :code => 403 )
        end
      end
    end
  end

end