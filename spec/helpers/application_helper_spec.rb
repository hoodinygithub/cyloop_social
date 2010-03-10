require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ApplicationHelper do
  
  describe "#nav_aux_login_url" do      
    describe "on home page" do
      before(:each) do 
        params.stub!(:fetch).with(:controller).and_return("pages")
        params.stub!(:fetch).with(:action).and_return("home")
        request.stub!(:uri).and_return("/")
      end
            
      it "should give a class of button-to to the form" do
        helper.nav_aux_login_url =~ /(dashboard)/i
      end            
    
      describe "on other pages" do
        before(:each) do 
          params.stub!(:fetch).with(:controller).and_return("radio")
          params.stub!(:fetch).with(:action).and_return("index")        
          request.stub!(:uri).and_return("/radio")
        end    
        it "should give a class of button-to to the form" do
          helper.nav_aux_login_url =~ /(radio)/i
        end    
      end      
    end

  end
  
end