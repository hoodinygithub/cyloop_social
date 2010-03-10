
class Player::Base < ActiveRecord::BaseWithoutTable

  def to_xml(options = {}, &block)
    options[:skip_types] = true
    options[:skip_blanks] = true
    serializer = CyloopXmlSerializer.new(self, options)
    block_given? ? serializer.to_s(&block) : serializer.to_s
  end

  class << self

    def from(object, options = {})
      if object.respond_to?(:each)
        object.map { |item| from_one(item, options) }
      else
        from_one( object, options )
      end
    end

    def from_one( object, options = {} )
      hash = case object
      when ActiveRecord::Base
        object.attributes
      else
        object
      end
      hash.merge!(options)
      hash.delete_if do |key,value|
        !column_names.include?(key.to_s)
      end
      record = new(hash)
      record.id = object.id
      record
    end

  end

end