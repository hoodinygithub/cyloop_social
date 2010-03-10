class ActiveSupport::Duration
  def to_s(type = nil)
    case type
    when nil
      super()
    when :duration
      if self < 3600
        "%d:%02d" % [self/60, self%60]
      else
        "%d:%02d:%02d" % [self/3600, (self/60)%60, self%60]
      end
    else
      super(type)
    end
  end
end
