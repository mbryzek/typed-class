module TypedClassInternal

  class Option

    attr_reader :klass

    def initialize(klass)
      @klass = ::TypedClassInternal::Util.assert_class(klass, Class)
    end

  end

end
