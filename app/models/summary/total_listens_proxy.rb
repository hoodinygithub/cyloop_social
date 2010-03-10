module Summary::TotalListensProxy
  class TotalListensProxy < BlankSlate
    attr_reader :total_listens, :max_listens
    def initialize(target, total_listens, max_listens = nil)
      @target = target
      @total_listens = total_listens
      @max_listens = max_listens
    end

    def ratio
      total_listens / max_listens.to_f
    end

    def method_missing(method, *args, &block)
      @target.send(method, *args, &block)
    end
  end
end
