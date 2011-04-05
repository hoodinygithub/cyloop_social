class LogsController < ApplicationController
  # External object logging
  def log
    level = params[:level]
    msg = params[:message]
    if level
      logger.send(level, CGI.unescape(msg))
    end
    render :text => level.to_s + ' - ' + CGI.unescape(msg.to_s)
  end
end
