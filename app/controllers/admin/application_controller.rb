class Admin::ApplicationController < ApplicationController
  layout "admin"
  before_filter :do_basic_http_authentication

private
  def do_basic_http_authentication
    authenticate_or_request_with_http_basic do |username, password|
      if Rails.env.staging?
        username == "hoodiny" && password == "3057227000"
      else
        username == "chat" && password == "ch0t3d"
      end
    end
  end
end