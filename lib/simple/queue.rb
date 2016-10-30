require "simple/queue/version"

module Simple
  class Queue
    def initialize
      @array = []
      @mutex = Mutex.new
    end

    def clear
      @mutex.synchronize { @array = [] }
    end

    def empty?
      @mutex.synchronize { @array.empty? }
    end

    def length
      @mutex.synchronize { @array.length }
    end
    alias_method :size, :length

    def push(obj)
      @mutex.synchronize { @array.push(obj) }
    end
    alias_method :<<, :push
    alias_method :enq, :push

    def pop(_=nil)
      @mutex.synchronize { @array.shift }
    end
    alias_method :deq, :pop
    alias_method :shift, :pop

    def num_waiting
      0
    end
  end
end
