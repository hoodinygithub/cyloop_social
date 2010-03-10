module JobsHelper
  def job_should_pass(job_class, job, *args, &block)
    yield if block_given?
    options = args.extract_options!
    status, message = job_class.process(job, options)
    status.should == true
    message.should be_nil
  end

  def job_should_fail_with_message(job_class, job, *args, &block)
    yield if block_given?
    options = args.extract_options!
    msg = options.delete(:message)
    status, message = job_class.process(job, options)
    status.should == false
    message.should =~ /#{msg}/i
  end
end