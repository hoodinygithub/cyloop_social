Array.class_eval do
  
  def uniq_by
    seen = Set.new
    inject([]) do |memo, object|
      criteria = yield(object)
      unless seen.include?(criteria)
        memo << object
        seen << criteria
      end
      memo
    end
  end

  def rand_list( size )
    return self if size >= self.size
    result = []
    while result.size < size
      item = rand
      result << item unless result.include?(item)
    end
    result
  end

end
