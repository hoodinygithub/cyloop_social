require 'spec_helper'

describe RegistrationLayersController do

  #Delete these examples and add some real ones
  it "should use RegistrationLayersController" do
    controller.should be_an_instance_of(RegistrationLayersController)
  end

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'follow_artist'" do
    it "should be successful" do
      get 'follow_artist'
      response.should be_success
    end
  end

  describe "GET 'follow_user'" do
    it "should be successful" do
      get 'follow_user'
      response.should be_success
    end
  end

  describe "GET 'add_song'" do
    it "should be successful" do
      get 'add_song'
      response.should be_success
    end
  end
  
  describe "GET 'radio_add_song'" do
    it "should be successful" do
      get 'radio_add_song'
      response.should be_success
    end
  end

  describe "GET 'add_mixer'" do
    it "should be successful" do
      get 'add_mixer'
      response.should be_success
    end
  end

  describe "GET 'max_song'" do
    it "should be successful" do
      get 'max_song'
      response.should be_success
    end
  end
  
  describe "GET 'max_radio'" do
    it "should be successful" do
      get 'max_radio'
      response.should be_success
    end
  end  
end