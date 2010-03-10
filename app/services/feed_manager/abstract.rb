class FeedManager::Abstract

  attr_reader :node
  def initialize(node)
    @node = node
  end

  def self.reader(*attributes, &block)
    attributes.each do |attribute|
      define_method(attribute) do
        read_attribute(attribute, &block)
      end
    end
  end

  def self.integer_reader(*attributes)
    reader(*attributes) {|value| Integer(value)}
  end

  def self.decimal_reader(*attributes)
    reader(*attributes) {|value| BigDecimal(value)}
  end

  def self.boolean_reader(*attributes)
    reader(*attributes) {|value| %w(1 Y).include?(value)}
  end

  def xpath(*args)
    @node.xpath(*args)
  end

  def read_attribute(key)
    element = xpath("./#{key}")
    if element.any?
      if block_given?
        yield(element.text.strip)
      else
        element.text.strip
      end
    end
  end

  def read_cp_attribute(key)
    read_attribute("cp:#{key}")
  end

  def read_attribute_only(key)
    element = xpath(".//@#{key}")
    if element.any?
      if block_given?
        yield(element.text.strip)
      else
        element.text.strip
      end
    end
  end

  def read_image_attribute(key)
    element = xpath("./#{key}")
    if element.any?
      element.text.split("/").last
    end
  end

  def read_title_src_from(key)
    source = read_attribute(key)
    begin
      part1 = source.split(/(em\>)/)[2]
      part1.split(/\<\/e/)[0]
    rescue
      ""
    end
  end

  def read_image_src_from(key)
    source = read_attribute(key)
    begin
      part1 = source.split(/(src=')/)[2]
      part1.split(/'/)[0]
    rescue
      ""
    end
  end


  def read_artist_src_from(key)
    source = read_attribute(key)
    part1 = source.split(/(Artista:\<\/strong\> )/)[2]
    part1 = source.split(/(Artista: \<\/strong\>)/)[2] if part1.nil?
    part1 = source.split(/(Artista:\ )/)[2] if part1.nil?
    part1.split(/\<br/)[0].gsub(/<\/?[^>]*>/, "")
  end

end

