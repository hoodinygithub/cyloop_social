
module Application::Rescues

  module InstanceMethods

    def render_xml_errors( errors )
      render :template => 'messenger_player/errors/index', :locals => { :errors => errors }
    end

    def _record_not_found
      respond_to do |format|
        format.html do
          unless params[:slug].blank?
            redirect_to profile_not_found_path(params[:slug])
          else
            render :file => File.join( RAILS_ROOT, 'public', "404.html" ), :status => 404
          end
        end
        format.xml  { render :xml => Player::Error.new( :code => 404, :error => t('messenger_player.record_not_found') ) }
      end
    end

    def _not_an_artist
      respond_to do |format|
        format.html { redirect_to user_path(params[:slug]) }
        format.xml  { render :xml => {:message => "Not an artist"} }
      end
    end

    def _not_an_user
      redirect_to login_path
    end

  end

  def self.included( base )
    base.class_eval do

      include Application::Rescues::InstanceMethods
      
      rescue_from ActiveRecord::RecordNotFound, :with => :_record_not_found
      rescue_from AuthenticatedSystem::NotAnArtist, :with => :_not_an_artist
      rescue_from AuthenticatedSystem::NotAnUser, :with => :_not_an_user

    end
  end

end