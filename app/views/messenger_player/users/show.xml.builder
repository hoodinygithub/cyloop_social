xml.instruct!
xml.user( :status => user_status ) do
  unless current_user.nil?
    [ :id, :slug, :name ].each do |field|
      xml.method_missing( field, current_user.send(field) )
    end
  end
end