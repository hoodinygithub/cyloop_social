module RegistrationLayersHelper  
  def onclick_to_with_gat_code(url, code)
    "Base.utils.redirect_layer_to('#{url}', '#{code}', event)"
  end
  
  def gat_code(code)
    "pageTracker._trackPageview('#{code}');"    
  end
  
  def layer_background_image
    srand Time.now.to_i
    # case current_site.code.to_s
    # when 'msnbr'
    #   image = rand(10)
    # when 'msnmx'
    #   image = rand(10)
    # when 'msnlatam'
    #   image = rand(10)
    # when 'msnlatino'
    #   image = rand(10)
    # when 'msncaen'
    #   image = rand(10)
    # when 'msncafr'
    #   image = rand(10)
    # else
      image = rand(10)
    # end
    "#{current_site.code}/#{(image + 1)}.jpg"
  end
end
