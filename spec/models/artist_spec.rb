require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Artist do

  describe 'on default find calls' do

    it 'should not find the artist if he is associated with the current site' do
      @artist = Factory(:artist, :site_ids => [ApplicationController.current_site.id])
      @artist.available_at_current_site?.should be_false
    end

  end

end