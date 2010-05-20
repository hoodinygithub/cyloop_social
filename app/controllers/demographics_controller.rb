class DemographicsController < ApplicationController
  # before_filter :login_required, :only => :update
  # 
  # def edit
  #   @user = current_user
  # end
  # 
  # def update
  #   @user = current_user
  #   params[:user] = trim_attributes_for_paperclip(params[:user], :avatar)
  #   if @user.update_attributes(params[:user])
  #     redirect_to artist_recommendations_path
  #   else
  #     render :action => :edit
  #   end
  # end
  
  def cities
    render :text => City.search("#{params[:q]}*", :field_weights => { :name => 50, :location => 10}).join("\n")
  end

end
