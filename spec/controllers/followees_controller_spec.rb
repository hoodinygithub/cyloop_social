require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe FolloweesController do

  before do
    Resque.stub!(:enqueue).and_return("OK")
    @user = Factory(:user)
    @user.update_attribute(:status, 'registered')
    @user.update_attributes( {:receives_following_notifications => true, :private_profile => false} )
    login_as @user
    
    @user_to_follow = Factory(:user)
  end

  shared_examples_for "successfull follow" do

    it "update should add a user to the current_user's list of followings" do
      do_action
      @user.followees.should include(@user_to_follow)
    end

    it 'should send the following notification when the user has it enabled' do
      controller.should_receive(:deliver_friend_request_email)
      do_action
    end

    it 'should not send the following notification when the user has it disabled' do
      @user.update_attribute( :receives_following_notifications, false )
      controller.should_not_receive(:deliver_friend_request_email)
      do_action
    end

    it 'should have the following as approved' do
      do_action
      assigns[:following].should_not be_new_record
      assigns[:following].should be_approved
    end

  end

  describe 'on PUT' do

    describe 'successfull HTML requests' do

      def do_action
        put :update, :id => @user_to_follow.id
      end

      it_should_behave_like "successfull follow"

      it 'should set the message to the flash' do
        do_action
        flash[:success].should == I18n.t('followings.create_success', :name => assigns[:following].followee.name)
      end

      it 'should show the blocked message when the user is blocked' do
        @user_to_follow.block( @user.id )
        do_action
        flash[:error].should == "#{Following.human_attribute_name('followee')} #{ActiveRecord::Error.new(assigns[:following],:followee, :has_blocked_you ).to_s}"
      end

    end

    describe ' successfull JS requests' do

      def do_action
        xhr :put, :update, :id => @user_to_follow.id
      end

      it_should_behave_like "successfull follow"

      it 'should not set anything to the flash' do
        do_action
        flash.should be_blank
      end

    end
    
  end


  it "destroy should remove a user from the current_user's list of followings" do
    @user.follow(@user_to_follow)
    delete :destroy, :id => @user_to_follow
    @user.followees.should_not include(@user_to_follow)
  end

end
