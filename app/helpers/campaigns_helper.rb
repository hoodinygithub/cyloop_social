module CampaignsHelper
  def ordered_link(attrs = {})
    if params[:sort_order] and params[:sort_field] == attrs[:field]
      current_order = params[:sort_order]
    else
      current_order = attrs[:default]
    end
    sort_to = current_order == 'asc' ? 'desc' : 'asc'
    link = attrs[:path]
    link << "?sort_order=#{sort_to}&sort_field=#{attrs[:field]}"

    if params[:page]
      link << "&page=#{params[:page]}"
    end
  
    link_label = attrs[:label] + "&nbsp;"
    link_label << (current_order == 'asc' ? image_tag('ord_up.png', :class => 'sort_arrow') : image_tag('ord_down.png', :class => 'sort_arrow'))
    link_to link_label, link
  end
  
  def custom_image_field(attrs = {})
    image_dimensions = attrs[:model_instance].send("#{attrs[:field]}_dimensions").to_s

    if attrs[:model_instance].send(attrs[:field]).send(:file?)
      image = image_tag(attrs[:model_instance].send("#{attrs[:field]}").send(:url), :width => '40', :height => '40')
    else
      image = "Not Found"
    end

    content = content_tag(:table, 
      content_tag(:tr, 
        content_tag(:td, attrs[:label] + "&nbsp;&nbsp;", :class => 'row1') + 
        content_tag(:td, attrs[:form].send('file_field', attrs[:field]), :class => 'row2') +
        content_tag(:td, content_tag('span', "WxH: " + image_dimensions, :class => 'campaigns_image_size'), :class => 'row3') +
        content_tag(:td, content_tag('span', "Preview: " + image, :class => 'campaigns_image_preview'), :class => 'row4')
      ), :class => 'invisible_table'
    ) 
  end
  
  def custom_text_field(attrs = {})
    content = content_tag(:table, 
      content_tag(:tr, 
        content_tag(:td, attrs[:label] + "&nbsp;&nbsp;", :class => 'row1 big') + 
        content_tag(:td, attrs[:form].send('text_field', attrs[:field]), :class => 'row2') +
        content_tag(:td, "example: #{attrs[:example]}", :class => 'row3 big2')
      ), :class => 'invisible_table'
    ) 
  end
end
