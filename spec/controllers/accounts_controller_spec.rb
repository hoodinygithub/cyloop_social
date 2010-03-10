require File.dirname(__FILE__) + '/../spec_helper'

describe AccountsController do

  before do

    Resque.stub!(:enqueue).and_return("OK")

  end

  describe 'basic' do

    before do
      @account = Factory(:artist)
    end

    it 'requires profile account for artist' do
      get :show, :slug => @account.slug
      response.should be_success
    end

    it 'requires profile not found' do
      get :show, :slug => "bad_slug"
      response.should be_redirect
    end

  end

  describe 'on GET show calls' do

    describe 'with HTML format' do

      before do
        @user = Factory(:user)
      end

      def do_get
        get :show, :slug => @user.slug
      end

      it 'should render the correct template for users' do
        do_get
        response.should render_template( 'users/show' )
      end

      it 'should render the correct template for actors' do
        @user = Factory(:artist)
        do_get
        response.should render_template('artists/show')
      end

      describe 'user with profile not available' do

        before do
          @user.site_ids = [ controller.send(:current_site).id ]
          @user.save!
        end

        it 'should redirect to profile not available' do
          do_get
          response.should redirect_to( profile_not_available_path(@user.slug) )
        end

      end

      describe 'with custom profile page' do

        before do
          @user = Factory(:user, :has_custom_profile => true, :slug => 'sonyericsson')
        end

        it "should render sonyericsson's custom profile page" do
          do_get
          response.should render_template("custom_profiles/sonyericsson")
        end

      end

      describe 'with non-main slug' do

        before do
          @account_slug = @user.account_slugs.create!( :slug => 'cool_slug' )
        end

        def do_get
          get :show, :slug => @account_slug.slug
        end

        it 'should redirect to the main account page' do
          do_get
          response.should redirect_to( user_path( @user.slug ) )
        end

      end

    end

    describe 'with RSS format' do

      integrate_views

      describe 'for users' do

        before do
          @song = Song.generate!
          @activities = [ {
              'record' => @song,
              'item' => { 'id' => @song.id },
              'type' => 'listen',
              'timestamp' => Time.now.to_i,
              'artist' => {'slug' => 'some', 'name' => 'name'},
              'user' => {'slug' => 'some', 'name' => 'name'}} ]
          @user = User.generate!
          @user.stub!( :transformed_activity_feed ).and_return( @activities )
          Account.stub!(:find).and_return( @user )
        end

        def do_get
          get :show, :format => 'rss', :slug => @user.slug
        end

        it 'should be sucess' do
          do_get
          response.should be_success
        end

        it 'should render the rss template' do
          do_get
          response.should render_template("accounts/show")
        end

      end

      describe 'for artists' do

        before do
          @song = Song.generate!
          @activities = [ {
              'record' => @song,
              'album' => { 'id' => 10, 'name' => 'sample' },
              'item' => { 'id' => @song.id },
              'type' => 'listen',
              'timestamp' => Time.now.to_i,
              'artist' => {'slug' => 'some', 'name' => 'name'} ,
              'user' => {'slug' => 'some', 'name' => 'name'}}]
          @artist = Artist.generate!
          @artist.stub!( :transformed_activity_feed ).and_return( @activities )
          Account.stub!(:find).and_return( @artist )
        end

        def do_get
          get :show, :format => 'rss', :slug => @artist.slug
        end

        it 'should be success' do
          do_get
          response.should be_success
        end

        it 'should render the artist rss template' do
          do_get
          response.should render_template("accounts/show")
        end

      end

    end

  end

end