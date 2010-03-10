require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ButtonHelper do
  describe "#button_tag_to" do
    subject do
      helper.button_tag_to("Text", "/url?name=a+value", :method => :put, :class => "special")
    end

    it "should give a class of button-to to the form" do
      should have_tag("form.button-to")
    end

    it "should attach HTML options to the button" do
      pending
      should have_tag("special")
    end

    it "should have exactly one div" do
      pending
      [subject, helper.button_tag_to("Get", "#", :method => :get)].each do |x|
        x.should have_tag("div", :count => 2)
        x.should have_tag("form > *", :count => 1)
      end
    end

    it "should have a button element" do
      pending
      should have_tag("button", "Text")
    end

    it "should strip query parameters from the url" do
      should_not have_tag("form[action*=?]", "?")
    end

    it "should use hidden field for query parameters" do
      should have_tag("input[type=hidden][name=name][value=a value]")
    end

    it "should use a hidden field for the request method" do
      should have_tag("input[type=hidden][name=_method][value=put]")
    end
  end
end
