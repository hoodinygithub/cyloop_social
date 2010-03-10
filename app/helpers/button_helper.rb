module ButtonHelper
  def submit_to(*args)
    ActionView::Helpers::UrlHelper.instance_method(:button_to).bind(self).call(*args)
  end
  
  def pill_link_to(content, href, options={})
    content = t("actions.#{content.to_s}") if content.kind_of?(Symbol)

    html_options = ""
    options.each_pair{ |key, value| html_options << "#{key.to_s}=\"#{value.to_s}\" " }
    #<a href="#{href}" #{html_options}>#{content}</a>
    #<button>#{content}</button>
    action_html = (options.has_key?(:disabled))? "<span #{html_options}>#{content}</span>" : "<a href=\"#{href}\" #{html_options}>#{content}</a>"
    html = <<-EOF
      <div class="pill_button clearfix">
        <div class="left"></div>
        #{action_html}
        <div class="right"></div>
      </div>
    EOF
  end

  def large_form_button_to(content, id = nil)
    content = t("actions.#{content.to_s}") if content.kind_of?(Symbol)
    html = "<div class=\"large_form_button\"><div class=\"left\"></div><input type=\"submit\" value=\"#{content}\"/><div class=\"right\"></div></div>"
  end
  
  def large_link_button_to(content, href="#", options={})
    large_blue_link_button_to(content,href,false,options)
  end
      
  def large_blue_link_button_to(content, href="#", blue=true, options={})
    content = t("actions.#{content.to_s}") if content.kind_of?(Symbol)
    html_options = ""
    options.each_pair{ |key, value| html_options << "#{key.to_s}=\"#{value.to_s}\" " }
    html = "<div class=\"large_form_button #{blue ? "large_form_button_blue" : ""}\" ><div class=\"left\"></div><a href=\"#{href}\" #{html_options}>#{content}</a><div class=\"right\"></div></div>"
  end
  
  def button_tag(content, options = {})
    content_tag(:button, content, options)
    
    # options = {:class => "pill_button"}.merge(options)
    # content = t("actions.#{content}") if content.kind_of?(Symbol)
    # content = content_tag(:span, content) unless content.starts_with?("<span")
    # content_tag(:button, content, options)
  end

  def button_tag_to(content, url = {}, html_options = {})
    html_options = html_options.stringify_keys
    button_options = html_options.slice!('method')
    html_options['class'] = 'button-to'
    url = url_for(url) unless url.kind_of?(String)
    base, query = *url.split("?", 2)
    skip_auto_width = button_options.fetch("skip_auto_width", false) == true ? 1 : 0

    content = t("actions.#{content.to_s}") if content.kind_of?(Symbol)

    output = form_tag(base, html_options)
        
    output << "<div class=\"pill_button clearfix\">"
    output << "<div class=\"left\"></div>"

    query.to_s.split(/[&;?]/).each do |input|
      key, value = *input.split("=", 2).map {|x| CGI.unescape(x)}
      output << tag(:input, :type => "hidden", :name => key, :value => value)
    end
    auto_width_style = !skip_auto_width ? "width:#{content.size}em" : nil
    output << tag(:input, :type => "submit", :value => content, :class => "pill_button", :style => auto_width_style)
    output << "<div class=\"right\"></div>"

    output << "</div></form>"
  end
  alias button_to button_tag_to

  def large_button_tag_to(content, url = {}, html_options = {})
    html_options = html_options.stringify_keys
    button_options = html_options.slice!('method')
    html_options['class'] = 'button-to'
    url = url_for(url) unless url.kind_of?(String)
    base, query = *url.split("?", 2)

    content = t("actions.#{content.to_s}") if content.kind_of?(Symbol)

    output = form_tag(base, html_options)
    # unless output.sub!(%r{</div>\Z}, '')
    #   output << "<div class=\"pill_button clearfix\">"
    #   output << "<div class=\"left\"></div>"
    # end
    output << "<div class=\"large_form_button\">"
    output << "<div class=\"left\"></div>"

    query.to_s.split(/[&;?]/).each do |input|
      key, value = *input.split("=", 2).map {|x| CGI.unescape(x)}
      output << tag(:input, :type => "hidden", :name => key, :value => value)
    end
    #output << button_tag(content, button_options)
    output << tag(:input, :type => "submit", :value => content)
    output << "<div class=\"right\"></div>"

    output << "</div></form>"
  end
  alias large_button_to large_button_tag_to
  
end
