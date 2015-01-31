module SimpleListing
  class Base
    attr_accessor :scope, :params
    private :scope=, :params=

    def initialize(scope, params)
      @scope, @params = scope, params
    end

    def perform
      yield self if block_given?
      scope
    end

    private

    def guard(message = nil)
      raise(ArgumentError, message) unless yield == true
    end
  end
end
