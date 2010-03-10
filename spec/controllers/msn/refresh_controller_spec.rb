require File.dirname(__FILE__) + '/../../spec_helper'

describe AccountsController do

  before do
    controller.stub!( :consent_token_cookie? ).and_return( true )
    controller.stub!( :consent_token_cookie ).and_return( 'consent-token' )
  end

end