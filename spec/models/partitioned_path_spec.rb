require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PartitionedPath do
  it 'should generate a write_path based on the user id' do
    PartitionedPath.path_for(1).should == ['0', '0', '1', '1']
    PartitionedPath.path_for(2).should == ['0', '0', '2', '2']
    PartitionedPath.path_for(1001).should == ['1', '0', '0', '1001']
    PartitionedPath.path_for(10001).should == ['1', '0', '0', '10001']
    PartitionedPath.path_for(10998).should == ['1', '0', '9', '10998']
  end
end