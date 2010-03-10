xml.instruct!
xml.errors do
  errors.each do |attr, value|
    xml.error( :attribute => attr ) do
      xml.cdata!( value )
    end
  end
end