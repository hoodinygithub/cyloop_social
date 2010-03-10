class CustomizationWriter
  include ERB::Util
  attr_reader :output_path
  CSS_TEMPLATE = File.join(RAILS_ROOT, 'app', 'views', 'shared', '_customized_page.css.erb')
  OUTPUT_DIRECTORY = File.join(RAILS_ROOT, 'public', 'system', 'backgrounds')
  BACKGROUND_ALIGNS = [:upper_left, :upper_center, :upper_right, :left, :center, :right, :lower_left, :lower_center, :lower_right]
  BACKGROUND_REPEATS = [:no_repeat, :full_repeat, :horizontal_repeat, :vertical_repeat]
  
  CUSTOMIZATION_CSS_VALUES = {
    :upper_left => 'top left',
    :upper_center => 'top center',
    :upper_right => 'top right',
    :left => 'center left',
    :center => 'center center',
    :right => 'center right',
    :lower_left => 'bottom left',
    :lower_center => 'bottom center',
    :lower_right => 'bottom right',
    :full_repeat => 'auto',
    :no_repeat => 'no-repeat',
    :horizontal_repeat => 'repeat-x',
    :vertical_repeat => 'repeat-y'
  }
  
  def self.css_path(user_id)
    "/system/backgrounds/#{PartitionedPath.path_for(user_id).join('/')}/user_style.css?#{Time.now.to_i}"
  end
  
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
  
  def symbol_to_css_value(symbol)
    return CUSTOMIZATION_CSS_VALUES[symbol.to_sym]
  rescue
    nil
  end
    
  def initialize(user, *args)
    @options = args.extract_options!
    @user    = user
    @output_path = File.join(OUTPUT_DIRECTORY, PartitionedPath.path_for(user.id))
  end
  
  def prepare_template
    b = binding
    template = IO.read(CSS_TEMPLATE)
    str = ERB.new(template, 0, "@user").result b
    str    
  end
  
  def write_css
    FileUtils.mkdir_p(@output_path)
    File.open(File.join(@output_path, 'user_style.css'), 'w') do |f|
      f.write(prepare_template)
    end
  end
  
  def remove_css
    FileUtils.rm_r(File.join(@output_path, 'user_style.css'))
  end
end
