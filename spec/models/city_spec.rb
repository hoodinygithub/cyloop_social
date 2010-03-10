require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe City do
  before(:each) do
    @valid_attributes = {
      :region_id => 1,
      :name => "value for name"
    }
  end

  it "should create a new instance given valid attributes" do
    City.create!(@valid_attributes)
  end
end
