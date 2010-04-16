unless Rails.env.development?
  HoptoadNotifier.configure do |config|
    config.api_key = '950da8268a21bb06642ea9ca5544d41c'
    config.ignore_user_agent << /(bot)|(spider)/i
  end
end