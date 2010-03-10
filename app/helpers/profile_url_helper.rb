module ProfileUrlHelper
  def method_missing(method, *args, &block)
    if respond_to?("user_#{method}")
      send("user_#{method}", params[:slug] || "my", *args)
    else
      super(method, *args, &block)
    end
  end
end
