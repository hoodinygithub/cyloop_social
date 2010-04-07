class JavascriptsController < ApplicationController
  CONFIG_PATH     = File.join(RAILS_ROOT, 'config')
  LOCALES_PATH    = File.join(CONFIG_PATH, 'locales')
  JAVASCRIPT_PATH = File.join(RAILS_ROOT, 'public', 'javascripts')
  
  def locale
    yml_file_path = File.join(CONFIG_PATH, 'javascript_locale.yml')
    keys          = YAML.load_file(yml_file_path)['keys'].split(" ")
    files = []
    
    @translations = {}
    Dir[File.join(LOCALES_PATH, '*.yml')].each do |file|
      locale_content         = YAML.load_file(file)
      language               = locale_content.keys.first
      locale_content         = locale_content[language]
      @translations[language] = {}

      keys.each do |key|
        key_to_eval = key.split('.').collect {|k| "['#{k}']"}.join("")
        element = eval("locale_content#{key_to_eval}") rescue nil
        @translations[language][key] = element
      end
    end
    
    content = render :layout => false, :mime_type => Mime::Type.lookup("application/javascript")
    open(File.join(JAVASCRIPT_PATH, 'locale.js'), 'w') do |file|
      file.write(content)
    end
  end
end
