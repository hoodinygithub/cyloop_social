require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Array do
  describe "#uniq_by" do
    it "should strip duplicates based on the block given" do
      array = [1, 1.5, 2]
      array.uniq_by {|f| f.to_i}.should == [1, 2]
    end
  end
end
