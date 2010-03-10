require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AccountLogin do

  describe 'on validations' do
    should_validate_presence_of(:site_id)
    should_validate_presence_of(:account_id)
  end

end