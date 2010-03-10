xml.instruct!
user_status = if logged_in?
  'logged_in'
elsif session[:msn_live_id]
  'msn_logged_in'
else
  'anonymous'
end
xml.user( :status => user_status ) do
  if current_user
    [ :id, :slug, :name ].each do |field|
      xml.method_missing( field, current_user.send(field) )
    end
  end
end