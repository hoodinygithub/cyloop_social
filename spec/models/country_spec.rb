require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Country do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :code => "value for code",
      :latitude => 9.99,
      :longitude => 9.99
    }
  end

  it "should create a new instance given valid attributes" do
    Country.create!(@valid_attributes)
  end
end
