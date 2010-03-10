require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ReservedSlug do
  it "should not allow empty slugs" do
    reserved_slug = Factory.build(:reserved_slug, :slug => '')

    reserved_slug.save.should be_false
    reserved_slug.errors.on(:slug).should_not be_blank
  end  
  
  it "should not allow two reserved slugs with the same slug" do
    reserved_slug           = Factory.build(:reserved_slug, :slug => 'daviscabral')
    identical_reserved_slug = Factory.build(:reserved_slug, :slug => 'daviscabral')

    reserved_slug.save.should be_true
    identical_reserved_slug.save.should be_false
    identical_reserved_slug.errors.on(:slug).should_not be_blank
  end
end
