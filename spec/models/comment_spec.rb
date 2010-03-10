require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Comment do
  it "should require an owner" do
    Comment.create.should have(1).error_on(:owner)
  end

  it "should require a body" do
    Comment.create.should have(1).error_on(:body)
  end

  it "should limit the body size" do
    Comment.create(:body => "x" * 65536).should have(1).error_on(:body)
  end
end
