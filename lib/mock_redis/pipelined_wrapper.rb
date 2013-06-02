class MockRedis
  class PipelinedWrapper
    include UndefRedisMethods

    def respond_to?(method, include_private=false)
      super || @db.respond_to?(method)
    end

    def initialize(db)
      @db = db
    end

    def initialize_copy(source)
      super
      @db = @db.clone
    end

    def method_missing(method, *args, &block)
      Struct.new(:value).new( @db.send(method, *args, &block) )
    end

    def pipelined(options = {})
      yield
    end
  end
end
