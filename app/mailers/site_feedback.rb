class SiteFeedback < BaseMailer

  def feedback(email_params, sent_at = Time.now)
    subject     "[Cyloop] #{truncate(email_params[:feedback])}"
    if site_includes(:msnbr)
      recipients  ENV['BR_FEEDBACK_EMAIL']
    elsif site_includes(:msnmx)
      recipients  ENV['MX_FEEDBACK_EMAIL']
    end
    from ActionMailer::Base.smtp_settings[:default_from]
    feedback    email_params[:feedback]
    os          email_params[:os]
    browser     email_params[:browser]
    country     email_params[:country]
    sent_on     sent_at
    
    body :feedback => email_params[:feedback], :sender_address => email_params[:address],
    :os => email_params[:os], :browser => email_params[:browser], :country => email_params[:country]
    
  end

end