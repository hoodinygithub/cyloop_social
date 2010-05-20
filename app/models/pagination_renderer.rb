class PaginationRenderer < WillPaginate::LinkRenderer
  include ButtonHelper

  def to_html
    links = @options[:page_links] ? windowed_links : []

    links = [
      page_link_or_span(@collection.previous_page, 'previous', @options[:previous_label], true),
      @template.content_tag( :span, links.join(@options[:separator]), :class => 'windowed_links' ),
      page_link_or_span(@collection.next_page, 'next', @options[:next_label], true)
      ]

    html = links.join(@options[:separator])
    @options[:container] ? @template.content_tag(:div, html, html_attributes) : html
  end

  protected

  def windowed_links
    prior_n=0
    links=[]
    visible_page_numbers.each do |n|
      if (n-1)== prior_n
        links.push(page_link_or_span(n, (n == current_page ? 'current' : nil)))
      else
        links.push(page_link_or_span(n, (n == current_page ? 'current' : nil),nil,nil,true))
      end
      prior_n=n
    end
    links
  end

  def page_link_or_span(page, span_class, text = nil, action=false, discontinuity=false)
    if discontinuity
      text ||= '... '+page.to_s
    else
      text ||= page.to_s
    end
    if page && page != current_page
      if(action)
        button_active(page, text, :class => span_class)
      else
        page_link(page, text, :class => span_class)
      end
    else
      if(action)
        button_disabled(page, text, :class => span_class)
      else
        page_span(page, text, :class => span_class)
      end
    end
  end

  def page_link(page, text, attributes = {})
    @template.link_to(text, url_for(page))
  end

  def button_active(page, text, attributes = {})
    @template.link_to text, url_for(page), :class=>'next_page'
  end

  def button_disabled(page, text, attributes = {})
    @template.link_to text, url_for(page), :class=>'disabled', :disabled => :true, :onclick => "return false;"
  end

  def page_span(page, text, attributes = {})
    @template.content_tag(:span, text, attributes)
  end

end

