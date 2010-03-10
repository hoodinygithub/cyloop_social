require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CustomizationWriter do
  before(:each) do
    @user = Factory(:user, :color_main_font => '000', :color_bg => 'fff')
    @expected_output = File.join(CustomizationWriter::OUTPUT_DIRECTORY, PartitionedPath.path_for(@user.id), 'user_style.css')
    FileUtils.rm_r(@expected_output) if File.exists?(@expected_output)
  end
  
  after(:each) do
    
  end
  
  it 'shoud not throw an error' do
    lambda { CustomizationWriter.new(@user) }.should_not raise_error
  end
  
  it 'should get a template' do
    cw = CustomizationWriter.new(@user)
    cw.prepare_template.should =~ /background/
  end
  
  it 'should write the template to a file' do
    File.exists?(@expected_output).should == false
    cw = CustomizationWriter.new(@user)
    cw.prepare_template
    cw.write_css
    File.exists?(@expected_output).should == true
    FileUtils.rm_r(@expected_output)
  end
  
  it 'should have the specified colors in it' do
    cw = CustomizationWriter.new(@user)
    cw.write_css
    actual_output = IO.read(@expected_output)
    actual_output.should =~ /#{@user.color_bg}/
    actual_output.should =~ /#{@user.color_main_font}/
  end
end