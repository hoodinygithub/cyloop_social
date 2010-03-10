
class CyloopXmlSerializer < ActiveRecord::XmlSerializer

  def add_tag(attribute)
    value = attribute.value.to_s
    unless value.blank? && options[:skip_blanks]
      builder.tag!(
        reformat_name(attribute.name),
        value,
        attribute.decorations(!options[:skip_types])
      )
    end

  end

end