require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CommentsController do
  describe "creating a comment" do
    def do_request
      post :create, :slug => @commentable.slug, :comment => {:body => 'body'}
    end
    private :do_request

    before :each do
      User.destroy_all
      @commentable = Factory(:user)
      @commentable.update_attribute(:status, 'registered')
    end

    it "should require a login to create a comment" do
      do_request
      response.should redirect_to(new_session_path)
    end

    describe "when logged in" do
      before do
        @current_user = Factory(:user)
        @current_user.update_attribute(:status, 'registered')
        login_as @current_user
      end

      it "should set the current user as the owner" do
        do_request
        assigns[:comment].owner.should == @current_user
      end

      it "should set a flash notice when comment is created" do
        do_request
        flash[:notice].should be
      end

      it "should redirect to the enclosing commentable's show action" do
        do_request
        response.should redirect_to(controller.url_for(@commentable))
      end

    end

  end

  describe "deleting a comment" do
    def do_request
      delete :destroy, :slug => @commentable.slug, :id => @comment.id
    end
    private :do_request

    before do
      @comment = Factory(:comment)
      @commentable = @comment.commentable
      @commentable.update_attribute(:status, 'registered')
    end

    describe "if the user owns the comment" do
      before do
        @owner = @comment.owner
        @owner.update_attribute(:status, 'registered')
        login_as @owner
      end

      it "should successfully delete if the user can delete the comment" do
        lambda { do_request }.should change(Comment, :count).by(-1)
      end

      it "should set a flash notice message if the user deletes the comment" do
        do_request
        flash[:notice].should be
      end

      it "should redirect to the enclosing user's show action" do
        do_request
        response.should redirect_to(user_path(@commentable))
      end

    end

    describe "if the user does not own the comment" do

      before do
        @user = Factory(:user)
        @user.update_attribute(:status, 'registered')
        login_as @user
      end

      it "should not delete the comment" do
        lambda { do_request }.should_not change(Comment, :count)
      end

    end

  end

end
