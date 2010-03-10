class CustomizationsController < ApplicationController
  
  before_filter :login_required
  
  def show
    redirect_to :action => :edit
  end
  
  def edit
    respond_to do |wants|
      wants.html { }
      wants.js   { render :layout => false }
    end
  end
  
  def update
    @user = current_user
    params[:user] = trim_attributes_for_paperclip(params[:user], :background)
    if @user.update_attributes(params[:user])
      respond_to do |wants|
        wants.html do
          flash[:success] = t('settings.saved')
          redirect_to my_dashboard_path
        end
        wants.js { render :nothing => true, :status => :ok }
      end
    else
      respond_to do |wants|
        wants.html do
          flash[:error] = t('settings.background_not_saved_image_too_large')
          redirect_to my_dashboard_path
        end
        wants.js { render :nothing => true, :status => 422 }
      end
    end
  end
  
  def restore_defaults
    flash[:success] = t('settings.customizations.reset_to_default')
    current_user.use_default_customizations!
    redirect_to my_dashboard_path
  end

  def remove_background_image
    flash[:success] = t('settings.saved')
    current_user.use_default_background_image!
    redirect_to my_dashboard_path
  end

end
