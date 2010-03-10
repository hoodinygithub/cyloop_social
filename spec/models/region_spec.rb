require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Region do
  before(:each) do
    @valid_attributes = {
      :country_id => 1,
      :name => "value for name",
      :code => "value for code"
    }
  end

  it "should create a new instance given valid attributes" do
    Region.create!(@valid_attributes)
  end
end
