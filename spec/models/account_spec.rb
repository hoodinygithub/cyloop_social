require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Account do

  describe 'on slug generation' do

    before do
      @account = Factory(:user)
    end

    it 'should generate a slug once an acount is created' do
      @account.account_slugs.first.slug.should == @account.slug
    end

    it 'should delete the slug when the account gets deleted' do
      @account.cancel_account!
      @account.account_slugs.should be_blank
    end

    it 'should set the account state to deleted' do
      @account.cancel_account!
      @account.status.should == 'deleted'
    end

  end

end