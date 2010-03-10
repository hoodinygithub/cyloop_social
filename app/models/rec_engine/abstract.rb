require "htmlentities"

class RecEngine::Abstract
  def marshal_dump
    @node.to_s
  end
  
  def marshal_load(body)
    @node = Nokogiri::XML.parse(body)
  end

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
    @node.search(*args)
  end

  def read_attribute(key)
    coder = HTMLEntities.new
    element = coder.decode(@node.search("#{key}").inner_html)
    # if element.any?
    #   if block_given?
    #     yield(element.text)
    #   else
    #     element.text
    #   end
    # end
  end

end
