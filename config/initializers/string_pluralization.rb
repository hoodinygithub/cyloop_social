class String
  def pluralize
    ActiveSupport::CoreExtensions::String::Inflections.instance_method(:pluralize).bind(self).call
  end
end
