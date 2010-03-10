module Account::ProfileColors

  DEFAULT_COLORS = {
    :header_bg => "025D8C",
    :main_font => "27343C",
    :links     => "025D8C",
    :bg        => "ECECEC"
  }
  
  DEFAULT_CUSTOMIZATIONS = {
    :background => nil,
    :background_repeat => nil,
    :background_fixed => nil,
    :background_align => nil
  }

  # TODO: Show how awesome ruby is by refactoring this
  
  def use_default_customizations!
    DEFAULT_CUSTOMIZATIONS.each_pair do |field, default_value|
      send("#{field}=".to_sym, default_value)
    end
    DEFAULT_COLORS.each_key do |field|
      send("color_#{field}=".to_sym, nil)
    end
    save
  end
  
  def use_default_colors!
    raise "This method has been deprecated."
  end
  
  def use_default_background_image!
    DEFAULT_CUSTOMIZATIONS.each_pair do |field, default_value|
      send("#{field}=".to_sym, default_value)
    end
    save
  end

end