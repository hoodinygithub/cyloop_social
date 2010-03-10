module CustomizationsHelper
  
  BACKGROUND_ALIGNS = [:upper_left, :upper_center, :upper_right, :left, :center, :right, :lower_left, :lower_center, :lower_right]
  BACKGROUND_REPEATS = [:no_repeat, :full_repeat, :horizontal_repeat, :vertical_repeat]
  # 
  # CUSTOMIZATION_CSS_VALUES = {
  #   :upper_left => 'top left',
  #   :upper_center => 'top center',
  #   :upper_right => 'top right',
  #   :left => 'center left',
  #   :center => 'center center',
  #   :right => 'center right',
  #   :lower_left => 'bottom left',
  #   :lower_center => 'bottom center',
  #   :lower_right => 'bottom right',
  #   :full_repeat => 'auto',
  #   :no_repeat => 'no-repeat',
  #   :horizontal_repeat => 'repeat-x',
  #   :vertical_repeat => 'repeat-y'
  # }
  # 
  def options_for_background_align
    BACKGROUND_ALIGNS.collect do |alignment|
      [t("user.background_alignments.#{alignment.to_s}"), alignment.to_s]
    end
  end
  
  def options_for_background_repeat
    BACKGROUND_REPEATS.collect do |repeat|
      [t("user.background_repeats.#{repeat.to_s}"), repeat.to_s]
    end
  end
  # 
  # def symbol_to_css_value(symbol)
  #   return CUSTOMIZATION_CSS_VALUES[symbol.to_sym]
  # rescue
  #   nil
  # end
  # 
  def customized_colors
    if user = profile_account
      stylesheet_link_tag "/profiles/#{user.slug}/customizations.css", :media => 'screen'
    end
    # if user = profile_account
    #   capture_haml do
    #     haml_tag :style, :type => 'text/css', :media => 'screen' do
    #       style = ''
    #       style << "#page_wrapper { color: ##{h user.color_main_font}; }" if user.color_main_font
    #       style << "#page_wrapper a, #page_wrapper a:visited, .navigation a, .additional_meta .time .count, .additional_meta .songs .count, span.count { color: ##{h user.color_links}; }" if user.color_links
    #       style << "#page_wrapper .chart div.bar, div#start_listening .button { background-color: ##{h user.color_links}; }" if user.color_links
    #       style << "#mast_head, #header_wrapper { background-color: ##{h user.color_header_bg}; }" if user.color_header_bg
    #       style << "body {"
    #       style << "background-color: ##{h user.color_bg};" if user.color_bg
    #       if user.background?
    #         style << "background-image: url('#{h user.background_file_name}');"
    #         style << "background-repeat: #{symbol_to_css_value user.background_repeat};" if user.background_repeat
    #         style << "background-attachment: #{user.background_fixed ? 'fixed' : 'scroll'};"
    #         style << "background-position: #{symbol_to_css_value user.background_align};"
    #       end
    #       style << "}"
    #       haml_concat style
    #     end
    #   end
    # end
  end
  
end
