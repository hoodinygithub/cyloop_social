require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Site do
  
  before(:all) do
    load_sites
  end
  
  before(:each) do
    Artist.destroy_all
    @site = Site.find_by_name('Cyloop')
    5.times { Factory(:artist) }
    Artist.all.each_with_index do |artist, total_listens|
      Factory(:top_artist, :artist_id => artist.id, :total_listens => total_listens, :site_id => @site.id)
    end
  end

  it "should load top artists from top artists cached table" do
    @site.summary_top_artists.first.total_listens.should == 4
  end
  
  it 'should have a cache-key based on the side id, code and default locale' do
    @site.cache_key.should == "sites/#{@site.id}/#{@site.updated_at.to_s(:number)}/cyloop/en"
  end
end